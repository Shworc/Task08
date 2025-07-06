# General
variable "location" {
  description = "Location for resource group."
  type        = string
}

variable "name_prefix" {
  description = "General prefix for all resources"
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}

# ACI
variable "aci_sku" {
  description = "SKU for for our container instance"
  type        = string
}

# ACR
variable "acr_sku" {
  description = "The SKU for the Azure Container Registry."
  type        = string
}

variable "context_repo_path" {
  description = "Repository for building docker image"
  type        = string
}

variable "git_pat" {
  description = "Token for access to repository"
  type        = string
  sensitive   = true
}

# KEYVAULT
variable "keyvault_sku_name" {
  description = "The SKU name of the Key Vault."
  type        = string
}

# REDIS
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
