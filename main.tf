# Example VPC configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc-${var.environment}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw-${var.environment}"
  }
}

# Example S3 bucket for storing artifacts
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "my-terraform-artifacts-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "artifact-bucket-${var.environment}"
    Environment = var.environment
  }
}

# Random string to ensure unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Example security group
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-${var.environment}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group-${var.environment}"
  }
}