output "redis_cache_name" {
  value       = azurerm_redis_cache.redis.name
  description = "The name of the Redis Cache."
}

output "redis_id" {
  description = "Azure Redis Cache Service ID"
  value       = azurerm_redis_cache.redis.id
}
