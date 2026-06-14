output "public_dns" {
  description = "Web server public dns"
  value       = aws_instance.web.public_dns
  sensitive   = true
}

output "subnet_id" {
  description = "Web server subnet id"
  value       = aws_instance.web.subnet_id
}