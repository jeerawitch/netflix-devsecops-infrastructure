resource "aws_security_group" "netflix_monitoring" {
  name        = "netflix-monitoring-sg"
  description = "Security Group for Netflix Monitoring DevSecOps Server"

  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "netflix-monitoring-sg"
  }
}


# -----------------------------
# SSH - 22
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "SSH"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# HTTPS - 443
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "HTTPS"

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Prometheus - 9090
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "prometheus" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "Prometheus"

  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Node_exporter - 9100
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "nodeexporter" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "Node_exporter"

  from_port   = 9100
  to_port     = 9100
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Grafana - 3000
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "Grafana"

  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Allow outbound traffic
# -----------------------------
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.netflix_monitoring.id

  description = "Allow all outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}