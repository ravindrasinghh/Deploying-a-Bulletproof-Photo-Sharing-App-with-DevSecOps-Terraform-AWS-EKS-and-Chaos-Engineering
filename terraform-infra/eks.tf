resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_config.cluster_name
  role_arn = aws_iam_role.demo.arn
  version  = var.cluster_config.cluster_version


  vpc_config {
    subnet_ids = [
      aws_subnet.private-ap-south-1a.id,
      aws_subnet.private-ap-south-1b.id,
      aws_subnet.public-ap-south-1a.id,
      aws_subnet.public-ap-south-1b.id
    ]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
  tags = {
    Name = "${local.project}-${var.env}-eks"
  }
}


resource "aws_eks_node_group" "private-nodes-01" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "private-nodes-01"
  node_role_arn   = aws_iam_role.nodes.arn
  version         = var.cluster_config.cluster_version

  subnet_ids = [
    aws_subnet.private-ap-south-1a.id,
    aws_subnet.private-ap-south-1b.id
  ]

  capacity_type  = "SPOT"
  instance_types = ["t3a.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }


  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name              = "${local.project}-${var.env}-eks"
    "node_group_name" = "private-nodes-01"
  }
   lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "private-nodes-02" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "private-nodes-02"
  node_role_arn   = aws_iam_role.nodes.arn
  version         = var.cluster_config.cluster_version

  subnet_ids = [
    aws_subnet.private-ap-south-1a.id,
    aws_subnet.private-ap-south-1b.id
  ]

  capacity_type  = "SPOT"
  instance_types = ["t3a.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }


  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name              = "${local.project}-${var.env}-eks"
    "node_group_name" = "private-nodes-02"
  }
   lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "node_additional_permissions" {
  name        = "eks-node-additional-permissions"
  description = "Allow EKS nodes to interact with KMS, DynamoDB, and S3 for specific operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*" # Specify your KMS key ARNs here if possible for better security
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = "arn:aws:dynamodb:ap-south-1:434605749312:table/PhotosMetadata" # Specify your table ARN
      },
      {
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = [
          "arn:aws:s3:::codedevops-staging-ui/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node-additional-permissions" {
  role       = aws_iam_role.nodes.name
  policy_arn = aws_iam_policy.node_additional_permissions.arn
}
# Attach AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "nodes-SSMManagedInstanceCore" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AmazonSSMFullAccess
resource "aws_iam_role_policy_attachment" "nodes-SSMFullAccess" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Attach AmazonEC2RoleforSSM (service-role)
resource "aws_iam_role_policy_attachment" "nodes-EC2RoleForSSM" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# Attach AmazonSSMManagedEC2InstanceDefaultPolicy
resource "aws_iam_role_policy_attachment" "nodes-SessionManager" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}
