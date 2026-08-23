output "web_server_public_ip" {
  description = "Public IP of the web server — load this in a browser to see the live site"
  value       = aws_instance.web.public_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}
