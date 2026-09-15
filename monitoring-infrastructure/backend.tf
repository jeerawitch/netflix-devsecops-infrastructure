terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-netflix-project"
    key    = "monitoring"
    region = "us-east-1"
  }
}
