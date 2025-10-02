resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "${var.prefix}-aks-identity"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-aks"

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_D2ads_v6"
    os_disk_type    = "Ephemeral"
    os_disk_size_gb = 75

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

resource "azurerm_key_vault_access_policy" "key_vault_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}
