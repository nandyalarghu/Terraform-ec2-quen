# Outputs from EC2 Instance Module

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.web_server.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.web_server.private_dns
}

output "instance_tags" {
  description = "Tags applied to the EC2 instance"
  value       = aws_instance.web_server.tags
}

output "eip_allocation_id" {
  description = "Allocation ID of the Elastic IP if created"
  value       = var.create_eip ? aws_eip.instance_eip[0].id : null
}

output "eip_public_ip" {
  description = "Public IP address of the Elastic IP if created"
  value       = var.create_eip ? aws_eip.instance_eip[0].public_ip : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group if created"
  value       = var.create_log_group ? aws_cloudwatch_log_group.instance_logs[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group if created"
  value       = var.create_log_group ? aws_cloudwatch_log_group.instance_logs[0].name : null
}