module "acm_backend" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "4.0.1"
  domain_name = "codedevops.cloud"
  subject_alternative_names = [
    "*.codedevops.cloud"
  ]
  zone_id             = data.aws_route53_zone.main.id
  validation_method   = "DNS"
  wait_for_validation = true
  tags = {
    Name = "${local.project}-${var.env}-backend-validation"
  }
}

data "aws_route53_zone" "main" {
  name = "codedevops.cloud." # Ensure the domain name ends with a dot

}

module "acm_cf" {
  source = "terraform-aws-modules/acm/aws"
  providers = {
    aws = aws.us-east-1
  }
  version     = "4.0.1"
  domain_name = "codedevops.cloud"
  subject_alternative_names = [
    "*.codedevops.cloud"
  ]
  zone_id             = data.aws_route53_zone.main.id
  validation_method   = "DNS"
  wait_for_validation = true
  tags = {
    Name = "${local.project}-${var.env}-backend-cloudfront"
  }
}
