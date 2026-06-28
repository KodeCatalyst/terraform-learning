variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable environment {
    description = "Deployment environment name"
    type        = string
}

variable "region" {
    description = "AWS region"
    type        = string
}
