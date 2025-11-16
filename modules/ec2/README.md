# Terraform EC2 Module

This module creates an EC2 instance with configurable parameters, including storage, security groups, IAM roles, and monitoring options.

## Features

- Configurable instance type and AMI
- Flexible storage configuration (root volume and additional EBS volumes)
- Support for IAM instance profiles
- CloudWatch log group creation
- Elastic IP allocation option
- Advanced metadata options
- Detailed monitoring support
- User data script support

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0

## Usage

```hcl
module "ec2_instance" {
  source = "path/to/ec2-module"

  name             = "my-ec2-instance"
  ami_id           = "ami-0c02fb55956c7d316"
  instance_type    = "t3.micro"
  key_name         = "my-key-pair"
  security_group_ids = [aws_security_group.web.id]
  subnet_id        = aws_subnet.public.id
  associate_public_ip = true

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

For more detailed examples, see the [examples](examples/) directory.