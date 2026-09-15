resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Custom security group for EKS worker nodes"

  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "nodeport_30007" {
  security_group_id = aws_security_group.eks_nodes.id

  description = "Allow application NodePort from my public IP"

  from_port   = 30007
  to_port     = 30007
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "node_exporter" {
  security_group_id = aws_security_group.eks_nodes.id

  description = "Allow Node Exporter inside VPC"

  from_port   = 9100
  to_port     = 9100
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}