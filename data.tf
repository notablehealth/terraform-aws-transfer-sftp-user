#data "aws_caller_identity" "current" {}
#data "aws_iam_account_alias" "current" {}
#data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_access_for_sftp_users" {
  #for_each = local.enabled ? local.user_names_map : {}

  statement {
    sid    = "AllowListingOfUserFolder"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      #each.value.s3_bucket_arn,
    ]
  }

  statement {
    sid    = "HomeDirObjectAccess"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObjectVersion",
      "s3:GetObjectACL",
      "s3:PutObjectACL"
    ]
    resources = [
      #var.restricted_home ? "${each.value.s3_bucket_arn}/${each.value.user_name}/*" : "${each.value.s3_bucket_arn}/*"
    ]
  }
}
