variable "region" {
    type = string
    default = "eu-north-1"
}

variable "environment" {
    description = "Deployment environment name e.g. dev, staging, prod"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
}