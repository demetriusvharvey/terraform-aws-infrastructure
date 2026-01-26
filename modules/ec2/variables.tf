variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "name" {
  description = "Name tag for the instance"
  type        = string
  default     = "terraform-demo-ec2"
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
}
