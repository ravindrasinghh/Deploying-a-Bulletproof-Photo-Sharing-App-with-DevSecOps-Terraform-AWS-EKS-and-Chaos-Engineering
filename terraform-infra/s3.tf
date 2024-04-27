# module "ui" {
#   source                  = "terraform-aws-modules/s3-bucket/aws"
#   version                 = "3.3.0"
#   bucket                  = "codedevops-${var.env}-ui"
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
#   attach_policy = true
#   policy        = data.aws_iam_policy_document.ui.json
#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }