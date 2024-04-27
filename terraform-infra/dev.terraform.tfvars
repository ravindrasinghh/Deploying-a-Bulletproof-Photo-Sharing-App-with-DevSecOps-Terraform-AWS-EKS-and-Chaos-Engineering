# Basic Environment Settings
env       = "staging"
ecr_names = ["codedevops"]
vpc_config = {
  region                  = "us-east-1"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support      = true
  vpc_cidr_block          = "10.20.0.0/16"
  pub_sub1_cidr_block     = "10.20.1.0/24"
  pub_sub2_cidr_block     = "10.20.2.0/24"
  private_sub1_cidr_block = "10.20.3.0/24"
  private_sub2_cidr_block = "10.20.4.0/24"
}

cluster_config = {
  cluster_name    = "codedevops"
  cluster_version = "1.29"
}



eks_managed_node_groups = {
  eks_node_group = {
    name             = "nodegroup-1"
    instance_types   = ["t3a.medium"]
    desired_capacity = 2
    min_capacity     = 1
    max_capacity     = 3
    capacity_type    = "ON_DEMAND"
  }
}

ui_conf = {
  cloudfront_default_certificate = null
  ssl_support_method             = "sni-only"
  minimum_protocol_version       = "TLSv1.2_2021"
}