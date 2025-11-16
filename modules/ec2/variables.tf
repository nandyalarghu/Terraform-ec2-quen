# Variables for EC2 Instance Module

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = "ec2-instance"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair to use for SSH access"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to the instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "Root volume type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
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
  default = []
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

variable "monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = false
}

variable "create_log_group" {
  description = "Whether to create a CloudWatch log group for the instance"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Number of days to retain logs in the CloudWatch log group"
  type        = number
  default     = 7
}

variable "ignore_changes" {
  description = "List of parameters to ignore changes for"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS region to deploy the instance in"
  type        = string
  default     = "us-east-1"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}