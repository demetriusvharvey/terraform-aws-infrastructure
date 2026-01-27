# Terraform AWS Infrastructure Project

This project demonstrates a production-style Terraform setup on AWS using best practices, including remote state management, reusable modules, and multi-environment deployments.

The infrastructure provisions an EC2 instance using a reusable Terraform module and supports separate **dev** and **prod** environments with isolated state files.

---

## 🧱 Architecture Overview

- **AWS EC2** – Compute resource
- **Terraform Modules** – Reusable EC2 module
- **Remote State (S3)** – Centralized Terraform state storage
- **State Locking (DynamoDB)** – Prevents concurrent applies
- **Multi-Environment** – Separate dev and prod deployments

---

## 📁 Project Structure

```text
terraform-ec2-basic/
├── bootstrap/                 # Creates S3 bucket + DynamoDB table
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── modules/
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── .gitignore
└── README.md

How It Works
1. Bootstrap (One-Time Setup)

The bootstrap/ folder provisions:

An S3 bucket for Terraform remote state

A DynamoDB table for state locking

This ensures Terraform state is centralized, versioned, and protected against concurrent modifications.

2. Terraform Module

The EC2 resource is defined in a reusable module:

Accepts inputs for AMI, instance type, key pair, and tags

Outputs instance ID and public IP

Designed to be environment-agnostic

3. Multi-Environment Deployment

Each environment (dev and prod) is its own Terraform root module:

Separate backend configuration

Separate state file in S3

Environment-specific variables

Same reusable EC2 module

Environments
Environment	Instance Type	State Path
dev	t3.micro	env/dev/ec2/terraform.tfstate
prod	t3.medium	env/prod/ec2/terraform.tfstate
▶️ Usage
Deploy Dev Environment
cd environments/dev
terraform init
terraform plan
terraform apply

Destroy Dev Environment
terraform destroy

Deploy Prod Environment
cd environments/prod
terraform init
terraform plan
terraform apply

🔒 Remote State & Locking

S3 stores the Terraform state file

DynamoDB provides state locking

Prevents multiple users or pipelines from running terraform apply at the same time

This setup mirrors real-world, team-based Terraform workflows.

📚 Skills Demonstrated

Terraform core concepts

Remote state management

State locking with DynamoDB

Terraform modules

Multi-environment infrastructure

AWS EC2 provisioning

Infrastructure as Code best practices

📝 Notes

Terraform commands should be run only from environment folders

terraform.tfvars files are excluded from version control

This project is intended for learning and demonstration purposes


