module "ui-cf" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  version                       = "3.4.0"
  comment                       = "Created from terraform"
  aliases                       = ["share.codedevops.cloud", "download.codedevops.cloud"]
  create_distribution           = true
  enabled                       = true
  is_ipv6_enabled               = true
  price_class                   = "PriceClass_All"
  retain_on_delete              = false
  wait_for_deployment           = false
  create_origin_access_identity = true
  origin_access_identities = {
    codedevops_ui = "ui"
  }
  origin = {
    ui = {
      domain_name = module.ui.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "codedevops_ui"
      }
    }
  }
  default_root_object = "index.html"
  default_cache_behavior = {
    target_origin_id       = "ui"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress               = true
    use_forwarded_values   = false
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  viewer_certificate = {
    cloudfront_default_certificate = var.ui_conf.cloudfront_default_certificate
    acm_certificate_arn            = module.acm_cf.acm_certificate_arn
    ssl_support_method             = var.ui_conf.ssl_support_method
    minimum_protocol_version       = var.ui_conf.minimum_protocol_version
  }
  custom_error_response = [
    {
      error_caching_min_ttl = "300"
      error_code            = "403"
      response_page_path    = "/index.html"
      response_code         = "200"
    }
  ]
}
