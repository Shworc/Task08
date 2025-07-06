variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "prefix" {
  description = "General prefix for all resources."
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

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
}

variable "context_repo_access_token" {
  description = "The access token for the context repository."
  type        = string
}

variable "context_repo_path" {
  description = "The URL of the repository, including branch and folder names."
  type        = string
}

variable "tags" {
  description = "A mapping of tags that should be assigned to resources."
  type        = map(string)
}
