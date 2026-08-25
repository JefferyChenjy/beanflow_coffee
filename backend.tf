# This file is used to configure the backend for Terraform state storage in an S3 bucket.
terraform {
  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "jeffery/beancoffee/terraform.tfstate"
    region = "us-east-1"
  }
}