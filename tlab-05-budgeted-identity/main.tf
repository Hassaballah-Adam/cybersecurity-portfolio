provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------------------------
# Random suffix so the bucket name is globally unique
# ---------------------------------------------------------------------------
resource "random_id" "id" {
  byte_length = 4
}

# ---------------------------------------------------------------------------
# Step 2 - The Financial Firewall
# Hard limit of $10.00/month, email alert at 80% of that threshold.
# ---------------------------------------------------------------------------
resource "aws_budgets_budget" "tlab_budget" {
  name         = "Titan-FinTech-Budget"
  budget_type  = "COST"
  limit_amount = "10.00"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = ["Hassaballahyaya@gmail.com"]
  }
}

# ---------------------------------------------------------------------------
# Step 3 - The Vault (S3 bucket, private by default)
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "vault" {
  bucket = "titan-fintech-vault-ha-${random_id.id.hex}"
}

resource "aws_s3_bucket_public_access_block" "vault" {
  bucket = aws_s3_bucket.vault.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "vault" {
  bucket = aws_s3_bucket.vault.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# ---------------------------------------------------------------------------
# Step 4 - The Surgical Identity
# Trust policy: only EC2 may assume this role.
# Permissions policy: only s3:PutObject, scoped to this bucket's ARN only
# (never a hardcoded ARN - always interpolated from the resource above).
# ---------------------------------------------------------------------------
resource "aws_iam_role" "vault_role" {
  name = "Titan-EC2-Vault-Role"

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

resource "aws_iam_policy" "vault_put_only" {
  name        = "Titan-Vault-PutObject-Only"
  description = "Least-privilege: allows PutObject to the Titan vault bucket only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.vault.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_put_only" {
  role       = aws_iam_role.vault_role.name
  policy_arn = aws_iam_policy.vault_put_only.arn
}

resource "aws_iam_instance_profile" "vault_profile" {
  name = "Titan-EC2-Vault-Profile"
  role = aws_iam_role.vault_role.name
}

# ---------------------------------------------------------------------------
# Step 5 - The Compute (Ubuntu, t2.micro, Free Tier), wearing the role
# ---------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "vault_ec2" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.vault_profile.name

  tags = {
    Name = "Titan-FinTech-Vault-Instance"
  }
}