variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Path to the public key for SSH access"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type = string
}