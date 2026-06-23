output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "redis_port" {
  value = aws_elasticache_replication_group.redis.port
}

output "memcached_endpoint" {
  value = aws_elasticache_cluster.memcached.cluster_address
}

output "memcached_port" {
  value = aws_elasticache_cluster.memcached.port
}