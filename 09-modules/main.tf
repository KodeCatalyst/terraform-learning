module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    environment = var.environment
}

module "staging_vpc" {
    source = "./modules/vpc"
    vpc_cidr = "10.1.0.0/16"
    environment = "staging"
}