terraform {
  backend "s3" {
    bucket = "nikhil-devops-terraform-state-bucket" # <-- REPLACE WITH YOUR UNIQUE BUCKET NAME
    key    = "global/s3/terraform.tfstate"
    region = "ap-south-2"
  }
}