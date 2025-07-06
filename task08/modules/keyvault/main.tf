resource "azurerm_key_vault" "key_vault" {
  name                     = var.keyvault_name
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  sku_name                 = var.keyvault_sku_name
  tenant_id                = var.tenant_id
  purge_protection_enabled = false

  tags = var.tags
}


resource "azurerm_key_vault_access_policy" "key_vault_policy_current_user" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]
}
