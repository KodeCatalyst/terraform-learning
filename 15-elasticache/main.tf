module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  region      = var.region
}

module "elasticache" {
  source              = "./modules/elasticache"
  environment         = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_id
  allowed_cidr       = module.vpc.vpc_cidr
  redis_node_type     = var.redis_node_type
  memcached_node_type = var.memcached_node_type
}