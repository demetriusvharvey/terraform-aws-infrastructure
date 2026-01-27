provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  tags = merge(var.tags, { Environment = "prod" })
}

module "ec2" {
  source = "../../modules/ec2"

  ami_id        = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  name          = var.name
  tags          = local.tags
}
