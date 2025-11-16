# Terraform Infrastructure

This repository contains the Terraform configuration for our infrastructure.

## Getting Started

1. Make sure you have Terraform installed on your system
2. Configure your AWS credentials using one of these methods:
   - AWS CLI profiles: `aws configure`
   - Environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   - IAM roles (if running on EC2)

## Backend Configuration

The Terraform state is stored in an S3 bucket with DynamoDB for state locking. 
See `backend.tf` for configuration details.

## Variables

- `aws_region`: AWS region to deploy resources to (default: us-east-1)
- `environment`: Environment name (default: dev)

## Deployment

To deploy the infrastructure:

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan -var="environment=dev"

# Apply changes
terraform apply -var="environment=dev"
```

## GitHub Actions CI/CD

This project uses GitHub Actions for continuous integration and deployment:
- Pull requests trigger `terraform plan` to preview changes
- Merging to main branch triggers `terraform apply` to deploy to production
- Secrets are stored as GitHub repository secrets

## Required Secrets

For GitHub Actions to work properly, the following secrets need to be configured in the repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `SLACK_WEBHOOK` (optional, for notifications)