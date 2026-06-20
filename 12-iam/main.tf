module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  region      = var.region
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
}

module "ec2" {
  source                = "./modules/ec2"
  environment           = var.environment
  instance_type         = var.instance_type
  public_key_path       = var.public_key_path
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.public_subnet_id
  instance_profile_name = module.iam.instance_profile_name
}