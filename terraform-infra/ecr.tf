resource "aws_ecr_repository" "foo" {
  for_each             = toset(var.ecr_names)
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  # image_scanning_configuration {
  #   scan_on_push = true

  # }
  #checkov:skip=CKV_AWS_163:ECR image scan on push is not enabled
}
