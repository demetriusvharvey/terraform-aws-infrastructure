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
