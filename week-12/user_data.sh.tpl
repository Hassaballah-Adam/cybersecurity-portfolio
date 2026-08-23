#!/bin/bash
set -e

# Install and start nginx
dnf install -y nginx
systemctl enable nginx
systemctl start nginx

# Deploy custom landing page
cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${project_name}</title>
  <style>
    body {
      margin: 0;
      font-family: -apple-system, Segoe UI, Roboto, sans-serif;
      background: #0f172a;
      color: #f1f5f9;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
    }
    .card {
      background: #1e293b;
      padding: 48px 64px;
      border-radius: 12px;
      border: 1px solid #334155;
    }
    h1 { color: #38bdf8; margin-bottom: 8px; }
    p { color: #94a3b8; margin: 4px 0; }
    .badge {
      display: inline-block;
      margin-top: 20px;
      padding: 6px 14px;
      background: #0369a1;
      border-radius: 999px;
      font-size: 13px;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hassaballah Adam</h1>
    <p>Cloud Security Engineering Capstone</p>
    <p>Terraform-provisioned VPC | Security-Group-Gated EC2 | tfsec CI/CD Pipeline</p>
    <div class="badge">Deployed via Infrastructure as Code</div>
  </div>
</body>
</html>
EOF

systemctl restart nginx
