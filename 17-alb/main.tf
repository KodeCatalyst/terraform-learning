module "vpc" {
    source = "./modules/vpc"
    environment = var.environment
    vpc_cidr = var.vpc_cidr
    region = var.region
}

module "alb" {
    source = "./modules/alb"
    environment = var.environment
    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    instance_ids = module.ec2.instance_ids
}

module "ec2" {
    source = "./modules/ec2"
    environment = var.environment
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnet_ids
    instance_type = var.instance_type
    public_key_path = var.public_key_path
    alb_security_group_id = module.alb.alb_security_group_id
}