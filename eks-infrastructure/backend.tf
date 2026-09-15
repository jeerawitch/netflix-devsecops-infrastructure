terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-netflix-project"
    key    = "eks"
    region = "us-east-1"
  }
}