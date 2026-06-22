module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  region      = var.region
}

module "rds" {
  source         = "./modules/rds"
  environment    = var.environment
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  instance_class = var.instance_class
  vpc_id         = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids
  allowed_cidr   = var.vpc_cidr
}