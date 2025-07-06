variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "keyvault_name" {
  description = "Name of key vault."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure subscription."
  type        = string
}

variable "current_user_object_id" {
  description = "The object ID for the Azure resource, typically a User Assigned Identity or Service Principal."
  type        = string
}

variable "keyvault_sku_name" {
  description = "The SKU name of the Key Vault."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources"
  type        = map(string)
}
