variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
}

variable "name" {
  type    = string
  default = "ec2-dev"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "terraform-learning"
    Owner   = "demetrius"
  }
}
