# Advanced Example - EC2 Instance with additional features
# This example demonstrates advanced usage of the EC2 instance module

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
resource "aws_vpc" "advanced" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "advanced" {
  vpc_id = aws_vpc.advanced.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.advanced.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}${var.availability_zone_suffix}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-public-subnet"
    Environment = var.environment
    Type        = "Public"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.advanced.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}${var.availability_zone_suffix}"

  tags = {
    Name        = "${var.vpc_name}-private-subnet"
    Environment = var.environment
    Type        = "Private"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.advanced.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.advanced.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-route-table"
    Environment = var.environment
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for Web Server
resource "aws_security_group" "web" {
  name_prefix = "${var.name_prefix}-web-"
  vpc_id      = aws_vpc.advanced.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_ingress_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.https_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-web-sg"
    Environment = var.environment
  }
}

# IAM Instance Profile (optional)
resource "aws_iam_instance_profile" "web_server" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "${var.name_prefix}-web-server-profile"
  role = aws_iam_role.ec2_role[0].name
}

# IAM Role for EC2 (optional)
resource "aws_iam_role" "ec2_role" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "${var.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role Policy (optional)
resource "aws_iam_role_policy" "ec2_policy" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "${var.name_prefix}-ec2-policy"
  role = aws_iam_role.ec2_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# EC2 Instance Module with advanced configuration
module "ec2_instance" {
  source = "../../modules/ec2"

  name             = var.instance_name
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  security_group_ids = [aws_security_group.web.id]
  subnet_id        = aws_subnet.public.id
  associate_public_ip = true
  iam_instance_profile = var.create_iam_instance_profile ? aws_iam_instance_profile.web_server[0].name : null

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Name        = var.instance_name
  }

  # Advanced storage configuration
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  root_volume_encrypted      = var.root_volume_encrypted
  root_volume_iops           = var.root_volume_iops
  root_volume_throughput     = var.root_volume_throughput
  root_volume_delete_on_termination = var.root_volume_delete_on_termination

  # Additional EBS volumes
  ebs_block_devices = var.ebs_block_devices

  # Metadata options
  metadata_http_endpoint               = var.metadata_http_endpoint
  metadata_http_tokens                 = var.metadata_http_tokens
  metadata_http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  metadata_instance_metadata_tags      = var.metadata_instance_metadata_tags

  # Monitoring
  monitoring = var.enable_monitoring

  # Create EIP and log group
  create_eip        = var.create_eip
  create_log_group  = var.create_log_group
  log_retention_days = var.log_retention_days

  # User data script with CloudWatch logs configuration
  user_data = var.enable_cloudwatch_logs ? <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd amazon-cloudwatch-agent
              
              # Start and enable httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello, World from $(hostname -f) in ${var.environment} environment</h1>" > /var/www/html/index.html
              
              # Create a custom log file
              echo "$(date): Server started" >> /var/log/myapp.log
              
              # Configure CloudWatch agent
              cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<INNEREOF
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "run_as_user": "root"
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/myapp.log",
                          "log_group_name": "/aws/ec2/${var.instance_name}",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              INNEREOF
              
              # Start CloudWatch agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
              EOF
              : var.user_data_script

  # Default tags
  default_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Output values
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = module.ec2_instance.instance_arn
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2_instance.instance_private_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2_instance.instance_public_dns
}

output "instance_private_dns" {
  description = "Private DNS of the EC2 instance"
  value       = module.ec2_instance.instance_private_dns
}

output "eip_allocation_id" {
  description = "Allocation ID of the Elastic IP if created"
  value       = module.ec2_instance.eip_allocation_id
}

output "eip_public_ip" {
  description = "Public IP of the Elastic IP if created"
  value       = module.ec2_instance.eip_public_ip
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group if created"
  value       = module.ec2_instance.cloudwatch_log_group_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.advanced.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}