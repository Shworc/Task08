variable "redis_name" {
  description = "Name of redis cache."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault."
  type        = string
}

variable "redis_sku_name" {
  description = "The SKU name of the Redis Cache."
  type        = string
}

variable "redis_primary_key_secret" {
  description = "Name of the secret for the Redis primary key in Azure Key Vault."
  type        = string
}

variable "redis_hostname_secret" {
  description = "Name of the secret for the Redis hostname in Azure Key Vault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}
