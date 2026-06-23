//Redis security group
resource "aws_security_group" "redis" {
  name       = "${var.environment}-redis-sg"
  description = "Allow redis traffic from VPC"
  vpc_id     = var.vpc_id

  ingress {
    description = "Redis from allowed CIDR"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

//Memcached security group
resource "aws_security_group" "memcached" {
  name = "${var.environment}-memcached-sg"
  description = "Allow memcached traffic from VPC"
  vpc_id = var.vpc_id

  ingress {
    description = "Memcached from allowed CIDR"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-memcached-sg"
    Environment = var.environment
  }
}


//Cache Subnet group for both memcache and redis
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-cache-subnet-group"
    Environment = var.environment
  }
}

//Redis replication group
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.environment}-redis"
  description          = "Redis cluster for ${var.environment}"

  node_type            = var.redis_node_type
  port                 = 6379
  num_cache_clusters   = 1

  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  //In my case I using 1 node and so setting automatic failover to false.
  //it should be true when I have multiple nodes
  automatic_failover_enabled = false

  tags = {
    Name = "${var.environment}-redis"
    Environment = var.environment
  }
}

//Memcached cluster
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "${var.environment}-memcached"
  engine               = "memcached"
  node_type            = var.memcached_node_type
  num_cache_nodes      = 1
  port                 = 11211

  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.memcached.id]

}