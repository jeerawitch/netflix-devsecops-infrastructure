terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-netflix-project"
    key    = "dev"
    region = "us-east-1"
  }
}
