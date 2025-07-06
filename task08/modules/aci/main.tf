data "azurerm_key_vault_secret" "redis_url" {
  name         = var.redis_hostname_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "redis_password" {
  name         = var.redis_primary_key_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_container_group" "aci" {
  name                = var.aci_name
  location            = var.res_group.location
  resource_group_name = var.res_group.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  dns_name_label      = "${var.prefix}-app"
  sku                 = var.aci_sku


  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_admin_username
    password = var.acr_admin_password
  }

  container {
    name   = "${var.prefix}-app"
    image  = "${var.acr_login_server}/${var.prefix}-app:latest"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      CREATOR        = "ACI"
      REDIS_PORT     = "6380"
      REDIS_SSL_MODE = "True"
    }

    secure_environment_variables = {
      REDIS_URL = data.azurerm_key_vault_secret.redis_url.value
      REDIS_PWD = data.azurerm_key_vault_secret.redis_password.value
    }
  }

  tags = var.tags
}
