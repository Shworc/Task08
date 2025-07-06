variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "aks_name" {
  description = "Name for aks."
  type        = string
}

variable "prefix" {
  description = "General prefix for all resources."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure subscription."
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the KeyVault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources."
  type        = map(string)
}
