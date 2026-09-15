# -----------------------------
# Default VPC
# -----------------------------
data "aws_vpc" "default" {
  default = true
}


# -----------------------------
# Latest Ubuntu 24.04 AMI
# -----------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -----------------------------
# Generate SSH Private Key
# -----------------------------
resource "tls_private_key" "netflix_monitoring" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# -----------------------------
# Create AWS Key Pair
# -----------------------------
resource "aws_key_pair" "netflix_monitoring" {
  key_name   = "netflix-monitoring-key"
  public_key = tls_private_key.netflix_monitoring.public_key_openssh

  tags = {
    Name = "netflix-monitoring-key"
  }
}

# -----------------------------
# Save Private Key as .pem
# -----------------------------
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.netflix_monitoring.private_key_pem
  filename        = "${path.module}/netflix-monitoring-key.pem"
  file_permission = "0400"
}


# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "netflix_monitoring" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.netflix_monitoring.key_name

  user_data = file("${path.module}/scripts/setup.sh")

  vpc_security_group_ids = [
    aws_security_group.netflix_monitoring.id
  ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    encrypted = true
  }

  tags = {
    Name = var.instance_name
  }
}


# -----------------------------
# Elastic IP
# -----------------------------
resource "aws_eip" "netflix_monitoring" {
  domain = "vpc"

  tags = {
    Name = "${var.instance_name}-eip"
  }
}


# -----------------------------
# Associate Elastic IP
# -----------------------------
resource "aws_eip_association" "netflix_monitoring" {
  instance_id   = aws_instance.netflix_monitoring.id
  allocation_id = aws_eip.netflix_monitoring.id
}