resource "aws_eks_node_group" "workers" {
  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${var.cluster_name}-workers"

  node_role_arn = aws_iam_role.eks_node.arn

  subnet_ids = data.aws_subnets.default.ids

  instance_types = [
    var.node_instance_type
  ]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id = aws_launch_template.eks_nodes.id

    version = aws_launch_template.eks_nodes.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.ecr_pull_only,
    aws_iam_role_policy_attachment.cni_policy
  ]

  tags = {
    Name        = "${var.cluster_name}-workers"
    Environment = "dev"
    Terraform   = "true"
  }
}