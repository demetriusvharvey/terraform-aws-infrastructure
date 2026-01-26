terraform {
  backend "s3" {
    bucket         = "tfstate-demetrius-2026-01-21-xyz123"
    key            = "ec2-basic/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}