# -----------------------------
# Default VPC
# -----------------------------

data "aws_vpc" "default" {
  default = true
}

# ดึง Subnet ที่กำหนดใน Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b"
    ]
  }
}

# -----------------------------
# EKS
# -----------------------------

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name        = var.cluster_name
    Environment = "dev"
    Terraform   = "true"
  }
}