# EC2 Instance Module
# This module creates an EC2 instance with configurable parameters

resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = var.iam_instance_profile

  tags = merge(
    {
      Name = var.name
      ManagedBy = "Terraform"
    },
    var.tags
  )

  user_data = var.user_data != null ? base64encode(var.user_data) : null

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.root_volume_encrypted
    iops                  = var.root_volume_iops
    throughput            = var.root_volume_throughput
    delete_on_termination = var.root_volume_delete_on_termination
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name = ebs_block_device.value.device_name
      volume_type = ebs_block_device.value.volume_type
      volume_size = ebs_block_device.value.volume_size
      encrypted   = ebs_block_device.value.encrypted
      iops        = lookup(ebs_block_device.value, "iops", null)
      throughput  = lookup(ebs_block_device.value, "throughput", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
    }
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_instance_metadata_tags
  }

  monitoring = var.monitoring

  lifecycle {
    ignore_changes = var.ignore_changes
  }
}

# Optional: Create an EIP for the instance if required
resource "aws_eip" "instance_eip" {
  count = var.create_eip ? 1 : 0

  instance = aws_instance.web_server.id
  domain   = "vpc"

  depends_on = [aws_instance.web_server]

  tags = merge(
    {
      Name = "${var.name}-eip"
    },
    var.tags
  )
}

# Optional: Create a CloudWatch log group for instance logs
resource "aws_cloudwatch_log_group" "instance_logs" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/ec2/${var.name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    {
      Name = "${var.name}-logs"
    },
    var.tags
  )
}