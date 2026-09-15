variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "Netflix"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for EKS"
  default     = "1.33"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for EKS worker nodes"
  default     = "t3.medium"
}