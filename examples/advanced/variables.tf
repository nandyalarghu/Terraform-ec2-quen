# Variables for Advanced Example

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone_suffix" {
  description = "Availability zone suffix (e.g., 'a', 'b', 'c')"
  type        = string
  default     = "a"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "terraform-ec2"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "advanced"
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
  default     = "advanced-ec2-instance"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the AWS key pair to use for SSH access"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "advanced-terraform-ec2-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.10.2.0/24"
}

variable "ssh_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # In production, use more restrictive CIDR
}

variable "http_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "root_volume_type" {
  description = "Root volume type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_iops" {
  description = "Root volume IOPS (for io1, io2, and gp3)"
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "Root volume throughput in MB/s (for gp3)"
  type        = number
  default     = null
}

variable "root_volume_delete_on_termination" {
  description = "Whether to delete the root volume on instance termination"
  type        = bool
  default     = true
}

variable "ebs_block_devices" {
  description = "List of EBS block device configurations"
  type = list(object({
    device_name           = string
    volume_type           = string
    volume_size           = number
    encrypted             = bool
    iops                  = optional(number)
    throughput            = optional(number)
    delete_on_termination = optional(bool, true)
  }))
  default = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 10
      encrypted   = true
    }
  ]
}

variable "metadata_http_endpoint" {
  description = "Whether the HTTP metadata endpoint is enabled or disabled"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether IMDSv2 is required or optional"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "Number of hops allowed when using the HTTP metadata endpoint"
  type        = number
  default     = 2
}

variable "metadata_instance_metadata_tags" {
  description = "Whether instance tags are accessible from the instance metadata"
  type        = string
  default     = "disabled"
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for the instance"
  type        = bool
  default     = true
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = false
}

variable "create_log_group" {
  description = "Whether to create a CloudWatch log group for the instance"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs in the CloudWatch log group"
  type        = number
  default     = 30
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM instance profile for the instance"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logs" {
  description = "Whether to configure CloudWatch logs on the instance"
  type        = bool
  default     = true
}

variable "user_data_script" {
  description = "User data script to run on instance launch (if CloudWatch logs are disabled)"
  type        = string
  default     = null
}