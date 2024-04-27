output "eks_values" {
  value = {
    node_group_name           = aws_eks_node_group.private-nodes.node_group_name
    node_group_arn            = aws_eks_node_group.private-nodes.arn
    node_group_status         = aws_eks_node_group.private-nodes.status
    node_group_capacity_type  = aws_eks_node_group.private-nodes.capacity_type
    node_group_instance_types = join(", ", aws_eks_node_group.private-nodes.instance_types)
    node_group_desired_size   = aws_eks_node_group.private-nodes.scaling_config[0].desired_size
    node_group_max_size       = aws_eks_node_group.private-nodes.scaling_config[0].max_size
    node_group_min_size       = aws_eks_node_group.private-nodes.scaling_config[0].min_size
  }
  description = "Values related to the AWS EKS managed node group"
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
