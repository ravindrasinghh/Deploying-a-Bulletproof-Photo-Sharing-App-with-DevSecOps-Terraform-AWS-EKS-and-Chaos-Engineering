module "ui" {
  source                  = "terraform-aws-modules/s3-bucket/aws"
  version                 = "3.3.0"
  bucket                  = "${local.project}-${var.env}-photoapp-ui"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.s3_policy.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
  #problem highlighted by tfsec is not that important to us and that it would be okay to ignore it. We can inform it to tfsec by adding a comment at the top of the resource block where this problem exists.
  #tfsec:ignore:<check-id>
