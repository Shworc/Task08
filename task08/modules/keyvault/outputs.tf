output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "The ID of the Key Vault."
}

output "key_vault_name" {
  value       = azurerm_key_vault.key_vault.name
  description = "The name of the Key Vault."
}

