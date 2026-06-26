output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "api_secret_arn" {
  value = aws_secretsmanager_secret.api_key.arn
}

output "db_credentials" {
  value     = data.aws_secretsmanager_secret_version.db_credentials.secret_string
  sensitive = true
}