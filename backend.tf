terraform {
  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "jeffery/beancoffee/terraform.tfstate"
    region = "us-east-1"
  }
}