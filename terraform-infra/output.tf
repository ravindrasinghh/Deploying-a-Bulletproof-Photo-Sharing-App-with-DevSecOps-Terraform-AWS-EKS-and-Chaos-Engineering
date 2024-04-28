output "eks_values_private_nodes_01" {
  value = {
    node_group_name           = aws_eks_node_group.private-nodes-01.node_group_name
    node_group_arn            = aws_eks_node_group.private-nodes-01.arn
    node_group_status         = aws_eks_node_group.private-nodes-01.status
    node_group_capacity_type  = aws_eks_node_group.private-nodes-01.capacity_type
    node_group_instance_types = join(", ", aws_eks_node_group.private-nodes-01.instance_types)
    node_group_desired_size   = aws_eks_node_group.private-nodes-01.scaling_config[0].desired_size
    node_group_max_size       = aws_eks_node_group.private-nodes-01.scaling_config[0].max_size
    node_group_min_size       = aws_eks_node_group.private-nodes-01.scaling_config[0].min_size
  }
  description = "Values related to the AWS EKS managed node group for private-nodes-01"
}

output "eks_values_private_nodes_02" {
  value = {
    node_group_name           = aws_eks_node_group.private-nodes-02.node_group_name
    node_group_arn            = aws_eks_node_group.private-nodes-02.arn
    node_group_status         = aws_eks_node_group.private-nodes-02.status
    node_group_capacity_type  = aws_eks_node_group.private-nodes-02.capacity_type
    node_group_instance_types = join(", ", aws_eks_node_group.private-nodes-02.instance_types)
    node_group_desired_size   = aws_eks_node_group.private-nodes-02.scaling_config[0].desired_size
    node_group_max_size       = aws_eks_node_group.private-nodes-02.scaling_config[0].max_size
    node_group_min_size       = aws_eks_node_group.private-nodes-02.scaling_config[0].min_size
  }
  description = "Values related to the AWS EKS managed node group for private-nodes-02"
}
output "ecr_repository_details" {
  description = "Details of the ECR repositories including URLs and ARNs"
  value = {
    for repo in aws_ecr_repository.foo :
    repo.name => {
      url = repo.repository_url
      arn = repo.arn
    }
  }
}
output "vpc_details" {
  value = {
    id                   = aws_vpc.vpc.id
    cidr_block           = aws_vpc.vpc.cidr_block
    instance_tenancy     = aws_vpc.vpc.instance_tenancy
    enable_dns_hostnames = aws_vpc.vpc.enable_dns_hostnames
    enable_dns_support   = aws_vpc.vpc.enable_dns_support
    internet_gateway     = aws_internet_gateway.igw.id
    allocation_id        = aws_eip.nat.id
    "private-ap-south-1a" = {
      id                = aws_subnet.private-ap-south-1a.id
      cidr_block        = aws_subnet.private-ap-south-1a.cidr_block
      availability_zone = aws_subnet.private-ap-south-1a.availability_zone
    }
    "private-ap-south-1b" = {
      id                = aws_subnet.private-ap-south-1b.id
      cidr_block        = aws_subnet.private-ap-south-1b.cidr_block
      availability_zone = aws_subnet.private-ap-south-1b.availability_zone
    }
    "public-ap-south-1a" = {
      id                = aws_subnet.public-ap-south-1a.id
      cidr_block        = aws_subnet.public-ap-south-1a.cidr_block
      availability_zone = aws_subnet.public-ap-south-1a.availability_zone
    }
    "public-ap-south-1b" = {
      id                = aws_subnet.public-ap-south-1b.id
      cidr_block        = aws_subnet.public-ap-south-1b.cidr_block
      availability_zone = aws_subnet.public-ap-south-1b.availability_zone
    }


  }
  description = "Details of the main VPC"
}
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.photos_metadata.name
  description = "The name of the DynamoDB table."
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.photos.id
  description = "The name of the S3 bucket."
}
output "cloudfront_url" {
  value       = module.ui-cf.cloudfront_distribution_arn
  description = "The URL of the CloudFront distribution."
}