terraform {
  backend "s3" {
    bucket         = "terraform-ec2-state-bucket"
    key            = "terraform-ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-ec2-locks"
  }
}