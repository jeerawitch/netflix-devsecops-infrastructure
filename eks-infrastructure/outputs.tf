output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "default_vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "Subnets used by EKS"
  value       = data.aws_subnets.default.ids
}

output "node_group_name" {
  description = "EKS managed node group"
  value       = aws_eks_node_group.workers.node_group_name
}