/**
 * # terraform-aws-transfer-sftp-user
 *
 * [![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-aws-transfer-sftp-user)](https://github.com/notablehealth/terraform-aws-transfer-sftp-user/releases)
 *
 * [Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/transfer-sftp-user/aws)
 *
 * Terraform module to manage AWS transfer service user
 *
 * Directory mappings are not fully supported currently
 *
 */

# TODO:
#   IAM policy for SSO S3 access

module "label" { # this - generate tags for user and base context
  #checkov:skip=CKV_TF_1:Local example
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["transfer", "sftp", "user"]
}
module "iam_label" { # generate iam names
  #checkov:skip=CKV_TF_1:Local example
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["transfer", "s3", var.sftp_user.user_name]
  context    = module.label.context
}
locals {
  s3_bucket_name = var.sftp_user.s3_bucket_name != null ? var.sftp_user.s3_bucket_name : var.s3_bucket_name
  s3_bucket_arn  = format("arn:aws:s3:::%s", local.s3_bucket_name)
}

###-------------------------
### IAM permissions
###-------------------------
resource "aws_iam_policy" "s3_access_for_sftp_users" {
  name   = module.iam_label.id
  policy = data.aws_iam_policy_document.s3_access_for_sftp_users.json
  tags   = module.label.tags
}

resource "aws_iam_role" "s3_access_for_sftp_users" {
  name                = module.iam_label.id
  assume_role_policy  = join("", [data.aws_iam_policy_document.assume_role_policy.json])
  managed_policy_arns = [aws_iam_policy.s3_access_for_sftp_users.arn]
  tags                = module.label.tags
}

###-------------------------
### S3 directory objects
###-------------------------
# User's home folder object
resource "aws_s3_object" "home_directory" {
  count  = var.create_home_folder && local.home_directory_type == "PATH" ? 1 : 0
  bucket = local.s3_bucket_name
  key    = var.sftp_user.user_name
}
# Need to also handle restricted home
# for_each = var.sftp_user.home_directory_mappings or if var.sftp_user.restricted_home then var.sftp_user.home_directory_mappings + {entry = "/", target="/bucket/user/"}
# || var.sftp_user.restricted_home
# Issues with versioned bucket?
#resource "aws_s3_object" "home_directory_mapping_targets" {
#  count  = (var.create_mapping_targets && local.home_directory_type == "LOGICAL") ? length(var.sftp_user.home_directory_mappings) : 0
#  bucket = local.s3_bucket_name
#  key    = var.sftp_user.home_directory_mappings[count.index].target
#  # target = /bucket/path
#  #bucket = split("/", target)[0]
#  #key    = join("/", slice(split("/", target), 1, -1)) # -1 might need to be length
#
#}

## Additional directory objects
resource "aws_s3_object" "additional_directories" {
  for_each = var.sftp_user.add_directories
  bucket   = local.s3_bucket_name
  key      = "${var.sftp_user.user_name}/${each.value}"
}

###-------------------------
### Transfer user
###-------------------------
# Restricted
#  {
#    entry  = "/",
#    target = "/s3-bucket/user"
#  }
locals {
  # Either restricted or mapping. Not both as the entry pathes cannot overlap
  directory_mappings = var.sftp_user.restricted_home ? [{
    entry = "/", target = format("/%s/%s", local.s3_bucket_name, var.sftp_user.user_name)
  }] : var.sftp_user.home_directory_mappings
  home_directory_type = length(local.directory_mappings) > 0 ? "LOGICAL" : "PATH"
  home_directory      = local.home_directory_type == "LOGICAL" ? null : (lookup(var.sftp_user, "home_directory", null) != null ? var.sftp_user["home_directory"] : "/${local.s3_bucket_name}/${var.sftp_user.user_name}")
}

resource "aws_transfer_user" "self" {
  server_id = var.aws_transfer_server_id
  role      = aws_iam_role.s3_access_for_sftp_users.arn
  #policy =
  user_name           = var.sftp_user.user_name
  home_directory_type = local.home_directory_type
  home_directory      = local.home_directory

  # TODO: support full mappings, not just when restricted
  # only if bucket is provided
  # TODO: handle empty set
  dynamic "home_directory_mappings" {
    # Only support restricted home
    for_each = local.directory_mappings
    #var.sftp_user.restricted_home ? [{
    #  entry = "/"
    #  # Specifically do not use $${Transfer:UserName} since subsequent terraform plan/applies will try to revert
    #  # the value back to $${Tranfer:*} value
    #  target = format("/%s/%s", local.s3_bucket_name, var.sftp_user.user_name)
    #}] : []
    #(
    #  lookup(var.sftp_user, "home_directory_mappings", null) != null ? lookup(var.sftp_user, "home_directory_mappings") : [
    #    {
    #      entry = "/"
    #      # Specifically do not use $${Transfer:UserName} since subsequent terraform plan/applies will try to revert
    #      # the value back to $${Tranfer:*} value
    #      target = format("/%s/%s", local.s3_bucket_name, var.sftp_user.user_name)
    #    }
    #  ]
    #) : toset([])

    content {
      entry  = home_directory_mappings.value["entry"]
      target = home_directory_mappings.value["target"]
    }
  }

  tags = module.label.tags
}

resource "aws_transfer_ssh_key" "self" {
  for_each   = var.sftp_user.public_key
  server_id  = var.aws_transfer_server_id
  user_name  = var.sftp_user.user_name
  body       = each.value
  depends_on = [aws_transfer_user.self]
}
