data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.ui.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [module.ui-cf.cloudfront_origin_access_identity_iam_arns.0]
    }
  }
}
