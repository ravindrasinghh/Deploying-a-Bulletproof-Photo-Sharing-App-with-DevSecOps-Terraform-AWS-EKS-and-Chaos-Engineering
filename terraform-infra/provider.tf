provider "aws" {
  region              = "ap-south-1"
  allowed_account_ids = [434605749312]
  default_tags {
    tags = {
      environment = var.env
      managedby   = "terraform"
    }
  }
}
provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = [434605749312]
  default_tags {
    tags = {
      environment = var.env
      managedby   = "terraform"
    }
  }
}
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.id]
      command     = "aws"
    }
  }
}
terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}
