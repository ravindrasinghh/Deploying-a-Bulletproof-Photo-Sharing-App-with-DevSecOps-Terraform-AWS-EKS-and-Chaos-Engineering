resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config.vpc_cidr_block
  instance_tenancy     = var.vpc_config.instance_tenancy
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  enable_dns_support   = var.vpc_config.enable_dns_support


  tags = {
    Name = "${local.project}-${var.env}-main"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.project}-${var.env}-igw"
  }
}
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${local.project}-${var.env}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-ap-south-1a.id

  tags = {
    Name = "${local.project}-${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_subnet" "private-ap-south-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_config.private_sub1_cidr_block
  availability_zone = "ap-south-1a"

  tags = {
    "Name"                                                     = "${local.project}-${var.env}-private-ap-south-1a"
    "kubernetes.io/role/internal-elb"                          = "1"
    "kubernetes.io/cluster/${var.cluster_config.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-ap-south-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_config.private_sub2_cidr_block
  availability_zone = "ap-south-1b"
  tags = {
    "Name"                                                     = "${local.project}-${var.env}-private-ap-south-1b"
    "kubernetes.io/role/internal-elb"                          = "1"
    "kubernetes.io/cluster/${var.cluster_config.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-ap-south-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_config.pub_sub1_cidr_block
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                     = "${local.project}-${var.env}-public-ap-south-1a"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/cluster/${var.cluster_config.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-ap-south-1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_config.pub_sub2_cidr_block
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                     = "${local.project}-${var.env}-public-ap-south-1b"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/cluster/${var.cluster_config.cluster_name}" = "owned"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.project}-${var.env}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.project}-${var.env}-public"
  }
}

resource "aws_route_table_association" "private-ap-south-1a" {
  subnet_id      = aws_subnet.private-ap-south-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-ap-south-1b" {
  subnet_id      = aws_subnet.private-ap-south-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-ap-south-1a" {
  subnet_id      = aws_subnet.public-ap-south-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-ap-south-1b" {
  subnet_id      = aws_subnet.public-ap-south-1b.id
  route_table_id = aws_route_table.public.id
}