# Cloud Security Engineering Capstone

**Author:** Hassaballah Adam
**Program:** The Knowledge House — Innovation Fellowship, Cybersecurity Track (Phase 2)

## Overview

A fully automated, secure cloud web deployment built with Terraform and gated by a
GitHub Actions security pipeline. The project provisions a custom AWS network from
scratch, deploys a web server into it, and enforces infrastructure security policy
before any code can reach `main`.

## Problem Statement

Manually provisioned cloud infrastructure is slow, inconsistent, and easy to
misconfigure — a single overly permissive security group rule (e.g., open SSH to
`0.0.0.0/0`) can expose an entire environment. This project solves that by:

1. Defining all infrastructure as code (Terraform), so every resource is
   reviewable, versioned, and repeatable.
2. Gating every change through an automated security scanner (tfsec) that fails
   the build if insecure configurations are introduced — before they ever reach
   AWS.

## Technologies Used

| Category | Tools |
|---|---|
| Infrastructure as Code | Terraform (AWS provider) |
| Cloud Provider | AWS (VPC, EC2, Security Groups, Internet Gateway, Route Tables) |
| CI/CD | GitHub Actions |
| Security Scanning | tfsec (SAST for Terraform) |
| Web Server | nginx (installed via EC2 user_data) |

## Architecture

- **Custom VPC** (`10.0.0.0/16`) with a public subnet (`10.0.1.0/24`)
- **Internet Gateway** + **route table** providing public internet access
- **Security Group** allowing:
  - Port 80 (HTTP) from anywhere, for public web access
  - Port 22 (SSH) restricted to a single admin IP only — never open to the world
- **EC2 instance** in the public subnet, auto-configured via `user_data` to
  install and start nginx, serving a custom landing page on boot
- **GitHub Actions pipeline** running tfsec on every push to `main`; the build
  fails if tfsec detects an insecure configuration (e.g., an open SSH rule),
  preventing it from ever being deployed

## Methodology

1. Wrote Terraform configuration (`main.tf`, `variables.tf`, `outputs.tf`)
   defining the VPC, subnet, routing, security group, and EC2 instance.
2. Wrote a `user_data` startup script to install nginx and deploy a custom
   landing page automatically at boot — no manual server configuration.
3. Built a GitHub Actions workflow using `tfsec-action`, triggered on push,
   to scan the Terraform code for security misconfigurations before deployment.
4. Ran `terraform plan` / `terraform apply` to provision the environment in AWS,
   verified the live public IP loaded the web server successfully.
5. Recorded a video walkthrough of the working pipeline and deployment.
6. Ran `terraform destroy` to tear down all billable resources and confirmed
   removal in the AWS console.

## Results

- Infrastructure deployed successfully with no manual console intervention.
- tfsec pipeline correctly passes on secure configuration and would fail the
  build on an insecure one (e.g., open SSH), demonstrating the security gate
  works as intended.
- Live web server reachable via the EC2 public IP, serving a custom landing page.
- Full infrastructure lifecycle (provision → verify → teardown) executed and
  confirmed at zero lingering AWS cost.

## Next Steps

- Add HTTPS via an Application Load Balancer + ACM certificate.
- Move the web server behind an Auto Scaling Group for resilience.
- Add remote Terraform state (S3 + DynamoDB locking) for team collaboration.
- Extend the pipeline with a `terraform plan` preview step on pull requests.

## Repository Structure

```
.
├── main.tf                       # VPC, subnet, IGW, route table, SG, EC2
├── variables.tf                  # Input variables
├── outputs.tf                    # Public IP, VPC ID, SG ID outputs
├── user_data.sh.tpl              # nginx install + landing page deploy script
├── terraform.tfvars.example      # Example variable values (copy to terraform.tfvars)
├── .github/workflows/tfsec.yml   # CI/CD security gate
└── README.md
```

## How to Deploy

```bash
# 1. Copy the example vars file and set your own SSH IP
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set ssh_allowed_cidr = "YOUR_IP/32"

# 2. Initialize and deploy
terraform init
terraform plan
terraform apply -auto-approve

# 3. Grab the live IP
terraform output web_server_public_ip

# 4. Tear down when finished (avoid ongoing AWS charges)
terraform destroy -auto-approve
```
