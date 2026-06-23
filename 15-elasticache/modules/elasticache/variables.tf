variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_cidr" {
  description = "CIDR block allowed to connect to the database"
  type        = string
}

variable "redis_node_type" {
  description = "ElastiCache node type for Redis"
  type = string
  default = "cache.t3.micro"
}

variable "memcached_node_type" {
  description = "ElastiCache node type for Memcached"
  type = string
  default = "cache.t3.micro"
}