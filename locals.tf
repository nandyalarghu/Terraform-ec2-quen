# Local values for the project

locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Provisioned = "Terraform"
  }
  
  default_instance_types = {
    dev     = "t3.micro"
    staging = "t3.small" 
    prod    = "t3.medium"
  }
  
  ami_map = {
    "us-east-1"     = "ami-0c02fb55956c7d316"
    "us-west-2"     = "ami-083ac7a7c137015fb"
    "eu-west-1"     = "ami-0d527b8c28943191e"
  }
}