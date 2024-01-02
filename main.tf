/**
 * # terraform-aws-transfer-sftp-user
 *
 * [![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-aws-transfer-sftp-user)](https://github.com/notablehealth/terraform-aws-transfer-sftp-user/releases)
 *
 * [Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/transfer-sftp-user/aws)
 *
 * Terraform module to manage AWS transfer service user
 *
 */

module "label" { # this - generate tags for user and base context
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["transfer", "sftp", "user"]
}
module "iam_label" { # generate iam names
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["transfer", "s3", each.value.user_name]
  context    = module.label.context
}

resource "aws_iam_policy" "s3_access_for_sftp_users" {
  name   = module.iam_label.id
  policy = data.aws_iam_policy_document.s3_access_for_sftp_users.json

  tags = module.label.tags
}

resource "aws_iam_role" "s3_access_for_sftp_users" {
  name = module.iam_label.id

  assume_role_policy  = join("", data.aws_iam_policy_document.assume_role_policy.json)
  managed_policy_arns = [aws_iam_policy.s3_access_for_sftp_users.arn]

  tags = module.label.tags
}

## OLD aws_s3_bucket_object
resource "aws_s3_object" "home_directory" {
  count         = var.create_home_folder && var.sftp_user.home_directory_type == "PATH" ? 1 : 0
  bucket        = var.sftp_user.s3_bucket_name
  key           = var.sftp_user.user_name
  force_destroy = true
}
# Need to also handle restrcited home
resource "aws_s3_object" "home_directory_mapping_targets" {
  count  = var.create_mapping_targets && var.sftp_user.home_directory_type == "LOGICAL" ? length(var.sftp_user.home_directory_mappings) : 0
  bucket = var.sftp_user.s3_bucket_name
  key    = var.sftp_user.home_directory_mappings[count.index].target
  # target = /bucket/path
  #bucket = split("/", target)[0]
  #key    = join("/", slice(split("/", target), 1, -1)) # -1 might need to be length

  force_destroy = true
}

resource "aws_transfer_user" "self" {
  server_id = var.aws_transfer_server_id
  role      = aws_iam_role.s3_access_for_sftp_users.arn
  #policy =
  user_name = var.sftp_user.user_name

  home_directory_type = lookup(var.sftp_user, "home_directory_type", null) != null ? lookup(var.sftp_user, "home_directory_type") : (var.sftp_user.restricted_home ? "LOGICAL" : "PATH")
  home_directory      = lookup(var.sftp_user, "home_directory", null) != null ? lookup(var.sftp_user, "home_directory") : (!var.sftp_user.restricted_home ? "/${lookup(var.sftp_user, "s3_bucket_name", var.sftp_user.s3_bucket_name)}" : null)

  # TODO: support full mappings, not just when restricted
  dynamic "home_directory_mappings" {
    for_each = var.sftp_user.restricted_home ? (
      lookup(var.sftp_user, "home_directory_mappings", null) != null ? lookup(var.sftp_user, "home_directory_mappings") : [
        {
          entry = "/"
          # Specifically do not use $${Transfer:UserName} since subsequent terraform plan/applies will try to revert
          # the value back to $${Tranfer:*} value
          target = format("/%s/%s", lookup(var.sftp_user, "s3_bucket_name", null), var.sftp_user.user_name)
        }
      ]
    ) : toset([])

    content {
      entry  = lookup(home_directory_mappings.value, "entry")
      target = lookup(home_directory_mappings.value, "target")
    }
  }

  tags = module.label.tags
}

resource "aws_transfer_ssh_key" "self" {
  for_each = var.sftp_user.public_key

  server_id = var.aws_transfer_server_id

  user_name = var.sftp_user.user_name
  body      = each.value

  depends_on = [
    aws_transfer_user.self
  ]
}
