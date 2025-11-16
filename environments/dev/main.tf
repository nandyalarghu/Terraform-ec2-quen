# Dev Environment Configuration

# This configuration demonstrates a development environment setup using the EC2 module.

module "dev_ec2" {
  source = "../../modules/ec2"

  name          = "dev-ec2-instance"
  ami_id        = "ami-0c02fb55956c7d316"
  instance_type = local.instance_type
  key_name      = var.key_name
  tags = merge(
    local.common_tags,
    {
      Environment = "dev"
      Project     = var.project_name
    }
  )
}

locals {
  instance_type = "t3.micro"
}

output "dev_instance_id" {
  description = "ID of the development EC2 instance"
  value       = module.dev_ec2.instance_id
}