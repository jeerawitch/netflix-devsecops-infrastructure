variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "netflix-jenkins"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

# variable "key_name" {
#   description = "Existing AWS EC2 Key Pair name"
#   type        = string
# }