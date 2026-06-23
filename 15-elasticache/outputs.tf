output "redis_endpoint" {
  value = module.elasticache.redis_endpoint
}

output "redis_port" {
  value = module.elasticache.redis_port
}

output "memcached_endpoint" {
  value = module.elasticache.memcached_endpoint
}

output "memcached_port" {
  value = module.elasticache.memcached_port
}