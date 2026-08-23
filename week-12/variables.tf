variable "project_name" {
  description = "Name prefix used to tag all resources"
  type        = string
  default     = "capstone-cloud-security"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023, us-east-1). Update if deploying to a different region."
  type        = string
  default     = "ami-0453ec754f44f9a4a"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH into the instance — set this to YOUR_IP/32, never 0.0.0.0/0"
  type        = string
  # Intentionally no default — you must set this in terraform.tfvars
  # so tfsec/reviewers can see SSH is deliberately restricted, not left open.
}
