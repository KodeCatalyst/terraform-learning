variable "instance_type" {
  description = "The type of ec2 instance"
  type        = string
  default     = "t3.micro"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC and subnet"
  type        = string
  default     = "10.5.0.0/16"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "terraform_demo"
}

variable "environment" {
  description = "Project environment"
  type        = string
  default     = "dev"
}