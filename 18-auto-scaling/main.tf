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
}

module "asg" {
    source = "./modules/asg"
    environment = var.environment
    vpc_id = module.vpc.vpc_id
    private_subnet_ids = module.vpc.private_subnet_ids
    alb_security_group_id = module.alb.alb_security_group_id
    target_group_arn = module.alb.target_group_arn
    instance_type = var.instance_type
    public_key_path = var.public_key_path
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
}