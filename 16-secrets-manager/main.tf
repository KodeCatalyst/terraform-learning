module "secrets" {
  source      = "./modules/secrets"
  environment = var.environment
  db_username = var.db_username
  db_password = var.db_password
  db_host     = var.db_host
  api_key     = var.api_key
}