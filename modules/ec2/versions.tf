# Terraform and Provider Configuration for EC2 Instance Module

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider configuration (can be overridden by parent modules)
provider "aws" {
  region = var.aws_region

  # Additional provider configuration can be added here
  default_tags {
    tags = var.default_tags
  }
}