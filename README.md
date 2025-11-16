# Terraform EC2 Infrastructure with CI/CD

This project provides a comprehensive Terraform module for creating EC2 instances with advanced configuration options. The module is designed to be reusable, flexible, and production-ready. It includes a complete CI/CD pipeline using GitHub Actions for automated deployments.

## Directory Structure

```
terraform-ec2/
├── modules/
│   └── ec2/                 # Main EC2 instance module
│       ├── main.tf          # EC2 instance resource definitions
│       ├── variables.tf     # Input variables for the module
│       ├── outputs.tf       # Output values from the module
│       ├── locals.tf        # Local variables for the module
│       └── versions.tf      # Terraform and provider version constraints
├── examples/
│   ├── simple/              # Simple EC2 instance example
│   └── advanced/            # Advanced configuration example
├── environments/
│   └── dev/                 # Development environment configuration
├── scripts/                 # Helper scripts for initialization and planning
├── tests/                   # Terraform test configurations
├── .github/
│   └── workflows/           # GitHub Actions workflow for CI/CD
├── .gitignore              # Git ignore patterns
├── .terraform-docs.yml     # Terraform documentation generation config
├── README.md               # This file
├── backend.tf              # Backend configuration for remote state
├── main.tf                 # Main configuration file
├── outputs.tf              # Output definitions
├── provider.tf             # Provider configuration
├── variables.tf            # Variable definitions
└── versions.tf             # Version constraints
```

## Features

- **Reusable EC2 Module**: A flexible Terraform module for creating EC2 instances with various configuration options
- **Environment Configuration**: Separate configurations for different environments (dev, staging, prod)
- **GitHub Actions CI/CD**: Automated testing, planning, and deployment pipeline
- **Infrastructure Testing**: Terraform test configurations to validate infrastructure code
- **Documentation**: Auto-generated documentation for modules and variables

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment:

- **Pull Request Checks**: On PR creation, the pipeline validates code, runs tests, and shows a Terraform plan
- **Automatic Deployment**: When changes are merged to main, infrastructure is automatically applied
- **Notifications**: Deployment status notifications to Slack

## Requirements

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- GitHub repository with configured secrets

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