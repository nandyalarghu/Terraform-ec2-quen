# Main Terraform Configuration
# This configuration deploys EC2 instances using the reusable EC2 module

# Data source to get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source to get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to get default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Using the EC2 module to create an instance
module "ec2_instance" {
  source = "./modules/ec2"

  name         = "${var.environment}-web-server"
  ami_id       = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name     = "my-key-pair"  # Replace with your key pair name
  subnet_id    = tolist(data.aws_subnets.default.ids)[0]
  security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      Module      = "EC2"
    }
  )
}

# Security group for the web server
resource "aws_security_group" "web_sg" {
  name_prefix = "${var.environment}-web-"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name        = "${var.environment}-web-sg"
      Environment = var.environment
    }
  )
}