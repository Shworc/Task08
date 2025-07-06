resource "azurerm_redis_cache" "redis" {
  name                = var.redis_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "C"
  sku_name            = var.redis_sku_name
  minimum_tls_version = "1.2"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "redis_primary_key" {
  name         = var.redis_primary_key_secret
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_hostname_secret
  value        = azurerm_redis_cache.redis.hostname
  key_vault_id = var.key_vault_id
}
