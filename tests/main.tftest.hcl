# Terraform Test Configuration for EC2 Module

# This test configuration verifies the functionality of the EC2 module

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Simple test case
module "test_ec2_simple" {
  source = "../modules/ec2"

  name          = "test-ec2-simple"
  ami_id        = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  tags = {
    Test = "simple"
  }
}

# Test case with additional features
module "test_ec2_advanced" {
  source = "../modules/ec2"

  name          = "test-ec2-advanced"
  ami_id        = "ami-0c02fb55956c7d316"
  instance_type = "t3.small"
  user_data     = "#!/bin/bash\necho 'Hello from test instance'"
  monitoring    = true
  create_log_group = true

  tags = {
    Test = "advanced"
  }
}

output "simple_instance_id" {
  value = module.test_ec2_simple.instance_id
}

output "advanced_instance_id" {
  value = module.test_ec2_advanced.instance_id
}