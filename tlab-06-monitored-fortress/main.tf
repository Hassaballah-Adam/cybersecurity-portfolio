provider "aws" {
  region = "us-east-1"
}

# ====================================================================
# TITAN FINTECH: THE MONITORED FORTRESS
# Build your VPC, Subnets, Flow Logs, Security Group, and EC2 instance below.
# 
# Hint: When your EC2 instance needs an IAM profile, use:
# iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
# 
# Hint: When your Flow Log needs an IAM role, use:
# iam_role_arn = aws_iam_role.flow_log_role.arn
# ====================================================================

# --- The Perimeter ---
resource "aws_vpc" "titan_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Titan-Prod-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.titan_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Titan-Public-Subnet"
  }
}

resource "aws_internet_gateway" "titan_igw" {
  vpc_id = aws_vpc.titan_vpc.id
  tags = {
    Name = "Titan-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.titan_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.titan_igw.id
  }
  tags = {
    Name = "Titan-Public-RT"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# --- The Wiretap ---
resource "aws_cloudwatch_log_group" "titan_flow_logs" {
  name              = "/tkh/titan-prod-vpc-logs"
  retention_in_days = 1
}

resource "aws_flow_log" "titan_wiretap" {
  vpc_id                = aws_vpc.titan_vpc.id
  log_destination       = aws_cloudwatch_log_group.titan_flow_logs.arn
  log_destination_type  = "cloud-watch-logs"
  traffic_type          = "ALL"
  iam_role_arn           = aws_iam_role.flow_log_role.arn
}

# --- The Zero Trust Compute ---
resource "aws_security_group" "zero_trust_sg" {
  name   = "Titan-Zero-Trust-SG"
  vpc_id = aws_vpc.titan_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # No ingress blocks — zero inbound access
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "titan_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.zero_trust_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "Titan-Zero-Trust-Node"
  }
}