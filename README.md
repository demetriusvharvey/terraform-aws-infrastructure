# AWS Multi-Environment Infrastructure with Terraform

**Infrastructure as Code portfolio project** | AWS EC2 · Terraform · S3 remote state · DynamoDB locking · reusable modules

This repository implements an AWS EC2 provisioning pattern with a shared Terraform module, separate development and production configurations, and distinct remote-state keys. The goal is to show how infrastructure can be defined, reviewed, reproduced, and torn down through code rather than manual console changes.

> **Scope:** This is a personal engineering project modeled after team infrastructure workflows—not a claim that it operates a production customer environment.

## Architecture

```text
                       Terraform CLI
                            |
               +------------+------------+
               |                         |
         bootstrap/               environments/
               |                 +-------+-------+
               |                 |               |
          S3 state bucket       dev/            prod/
          DynamoDB lock         |                |
               ^               module/ec2       module/ec2
               |                 |                |
        Separate state keys   EC2 (t3.micro)  EC2 (t3.medium)
```

- `bootstrap/main.tf` creates a versioned S3 state bucket with AES-256 server-side encryption and public-access blocking, plus a pay-per-request DynamoDB lock table.
- `modules/ec2/` provides a reusable EC2 resource with inputs for AMI, instance size, SSH key pair, name, and tags; outputs include the instance ID and public IP.
- `environments/dev/` and `environments/prod/` reuse the same module with different size defaults and environment tags.
- The remote backends use separate state paths: `env/dev/ec2/terraform.tfstate` and `env/prod/ec2/terraform.tfstate`.

## Repository layout

```text
bootstrap/               # S3 backend + DynamoDB table
modules/ec2/             # Shared EC2 module
environments/dev/        # Dev configuration and S3 backend
environments/prod/       # Prod configuration and S3 backend
main.tf                  # Standalone root configuration
backend.tf               # Standalone root backend
```

## Deployment procedure

**Prerequisites:** Terraform, AWS CLI with credentials authorized to create EC2/S3/DynamoDB resources, an existing EC2 key pair in `us-east-1`, and an AWS account with billing enabled.

1. Review `bootstrap/terraform.tfvars` and replace the sample state-bucket name if unavailable. The backend bucket names in `backend.tf` and both environment backend files must match the bucket you actually create.
2. Create the backend resources:

   ```bash
   terraform -chdir=bootstrap init
   terraform -chdir=bootstrap plan
   terraform -chdir=bootstrap apply
   ```

3. Initialize and plan the **dev** environment using an existing EC2 key pair:

   ```bash
   terraform -chdir=environments/dev init
   terraform -chdir=environments/dev fmt -check
   terraform -chdir=environments/dev validate
   terraform -chdir=environments/dev plan -var="key_name=YOUR_EC2_KEY_PAIR"
   terraform -chdir=environments/dev apply -var="key_name=YOUR_EC2_KEY_PAIR"
   ```

4. Repeat for `environments/prod` only if needed, after checking the instance size and cost.
5. Tear down EC2 resources when finished: `terraform -chdir=environments/dev destroy -var="key_name=YOUR_EC2_KEY_PAIR"`. Do **not** destroy the bootstrap state bucket while environment states still depend on it.

No credentials or private keys should be committed. The Terraform configurations assume the operator supplies authorized AWS credentials through the normal AWS provider credential chain.

## What this demonstrates

- **Build:** parameterized EC2 instances from one module, with separate environment configuration.
- **Change control:** `fmt`, `validate`, `plan`, and human review before `apply`.
- **State management:** remote S3 backends, distinct state paths, and DynamoDB-based locking as configured in this repository.
- **Troubleshooting:** inspect `terraform plan` drift, verify `aws sts get-caller-identity`, check AMI availability, key-pair region, backend permissions, and EC2 state if a deployment fails.
- **Cost discipline:** run `destroy` for unused test resources and review chargeable AWS services before provisioning.

## Operational considerations and next improvements

The current module does **not** create a dedicated VPC, security group, private subnet, load balancer, or application-monitoring stack. These are sensible future extensions, not capabilities claimed by this code.

- Use a dedicated VPC and restricted security groups, IAM least privilege, and stronger automated policy checks.
- Add pull-request CI for `terraform fmt`/`validate`/`plan`, along with reviewer approval before changes.
- Consider modernizing Terraform state locking for supported Terraform versions after validating the backend migration.
- **Repository hygiene:** an old `terraform.tfstate.backup` file is currently tracked in this repository despite `.gitignore` rules. Review it for sensitive data, remove it from Git/history if appropriate, and rotate any exposed secrets or keys. Adding an ignore rule does not untrack existing files.

## Interview walkthrough

Be ready to explain why reusable modules reduce duplicated configuration; how two environments stay isolated despite sharing code; what remote state and locking protect against; and how you would investigate failed initialization, permissions, drift, or an unexpected EC2 bill.

**Related skills:** AWS EC2 · Terraform HCL · modules · S3 backends · DynamoDB locking · environment isolation · infrastructure troubleshooting
