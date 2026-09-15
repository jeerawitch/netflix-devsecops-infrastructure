resource "aws_launch_template" "eks_nodes" {
  name_prefix = "${var.cluster_name}-nodes-"

  vpc_security_group_ids = [
    aws_security_group.eks_nodes.id,

    aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-worker"
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"

    http_put_response_hop_limit = 2
  }
}