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
  statement {
    sid    = "AllowListingOfUserFolder"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      local.s3_bucket_arn
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
      var.sftp_user.restricted_home ? "${local.s3_bucket_arn}/${var.sftp_user.user_name}/*" : "${local.s3_bucket_arn}/*"
    ]
  }
}
