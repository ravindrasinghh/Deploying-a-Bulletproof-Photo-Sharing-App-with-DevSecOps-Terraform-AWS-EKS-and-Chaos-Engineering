data "aws_iam_policy_document" "ui" {
  statement {
    effect = "Deny"
    sid    = "DenyIncorrectEncryptionHeader"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${module.ui.s3_bucket_arn}",
      "${module.ui.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }
  statement {
    effect = "Deny"
    sid    = "DenyUnEncryptedObjectUploads"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${module.ui.s3_bucket_arn}",
      "${module.ui.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
  statement {
    effect = "Deny"
    sid    = "AllowSSLRequestsOnly"
    actions = [
      "s3:*"
    ]
    resources = [
      "${module.ui.s3_bucket_arn}",
      "${module.ui.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.ui.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [module.ui-cf.cloudfront_origin_access_identity_iam_arns.0]
    }
  }
}



data "aws_caller_identity" "current" {}
