# Terraform EC2 Module

This project provides a comprehensive Terraform module for creating EC2 instances with advanced configuration options. The module is designed to be reusable, flexible, and production-ready.

## Directory Structure

```
terraform-ec2/
├── modules/
│   └── ec2/                 # Main EC2 instance module
├── examples/
│   ├── simple/              # Basic example of module usage
│   └── advanced/            # Advanced example with additional features
├── tests/                   # Test configurations
├── scripts/                 # Utility scripts
├── data-sources/            # Data sources for the project
├── locals/                  # Local values definitions
├── variables/               # Common variables
├── outputs/                 # Common outputs
└── environments/
    ├── dev/                 # Development environment
    ├── staging/             # Staging environment
    └── prod/                # Production environment
```

## Features

- **Modular Design**: The core EC2 instance logic is encapsulated in a reusable module
- **Flexible Configuration**: Supports a wide range of EC2 instance configurations
- **Storage Options**: Configurable root volumes and additional EBS volumes
- **Security**: Supports security groups and IAM instance profiles
- **Monitoring**: Configurable CloudWatch monitoring and logging
- **Networking**: Flexible networking configuration with VPC and subnet options
- **Metadata Options**: Support for IMDSv2 and other metadata configurations

## Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- AWS Account with appropriate permissions

## Quick Start

1. Navigate to one of the example directories:

```bash
cd examples/simple
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the execution plan:

```bash
terraform plan
```

4. Apply the configuration:

```bash
terraform apply
```

## Examples

### Simple Example
The simple example demonstrates basic usage of the EC2 module with minimal configuration.

### Advanced Example
The advanced example shows more complex configurations including additional EBS volumes, CloudWatch logging, IAM roles, and detailed monitoring.

## Module Inputs

For a complete list of inputs, see the module's [README](modules/ec2/README.md) and [variables](modules/ec2/variables.tf).

## Module Outputs

For a complete list of outputs, see the module's [outputs](modules/ec2/outputs.tf).

## Testing

Terraform configurations in the `tests/` directory can be used to validate the module functionality.