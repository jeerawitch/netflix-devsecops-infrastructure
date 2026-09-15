resource "aws_security_group" "netflix_jenkins" {
  name        = "netflix-jenkins-sg"
  description = "Security Group for Netflix Jenkins DevSecOps Server"

  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "netflix-jenkins-sg"
  }
}


# -----------------------------
# SSH - 22
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "SSH"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# HTTP - 80
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "HTTP"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# HTTPS - 443
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "HTTPS"

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Jenkins - 8080
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "Jenkins"

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Application - 8081
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "app" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "Application"

  from_port   = 8081
  to_port     = 8081
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# SonarQube - 9000
# -----------------------------
resource "aws_vpc_security_group_ingress_rule" "sonarqube" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "SonarQube"

  from_port   = 9000
  to_port     = 9000
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# -----------------------------
# Allow outbound traffic
# -----------------------------
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.netflix_jenkins.id

  description = "Allow all outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}