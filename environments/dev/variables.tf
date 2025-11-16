# Variables for Dev Environment

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-ec2-dev"
}

variable "key_name" {
  description = "Name of the AWS key pair to use for SSH access"
  type        = string
  default     = null
}