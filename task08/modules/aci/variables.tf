variable "res_group" {
  description = "Infromation about resource group."
  type = object({
    name     = string
    location = string
  })
}

variable "aci_name" {
  description = "Name for aci module."
  type        = string
}

variable "prefix" {
  description = "General prefix for all resources."
  type        = string
}

variable "key_vault_id" {
  description = "Key vault id to get redis secrets."
  type        = string
}

variable "aci_sku" {
  description = "SKU for for container instance."
  type        = string
}

variable "acr_login_server" {
  description = "Azure container registry login server."
  type        = string
}

variable "acr_admin_username" {
  description = "Azure container registry admin login."
  type        = string
}

variable "acr_admin_password" {
  description = "Azure container registry admin password."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "Name of the secret containing redis hostname."
  type        = string
}

variable "redis_primary_key_secret_name" {
  description = "Name of the secret containing redis key."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources."
  type        = map(string)
}
