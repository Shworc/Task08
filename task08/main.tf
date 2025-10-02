data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "aci" {
  source = "./modules/aci"

  aci_name                      = local.aci_name
  prefix                        = var.name_prefix
  aci_sku                       = var.aci_sku
  acr_login_server              = module.acr.acr_login_server
  acr_admin_username            = module.acr.acr_admin_username
  acr_admin_password            = module.acr.acr_admin_password
  res_group                     = azurerm_resource_group.resource_group
  key_vault_id                  = module.keyvault.key_vault_id
  redis_hostname_secret_name    = var.redis_hostname_secret
  redis_primary_key_secret_name = var.redis_primary_key_secret
  tags                          = var.tags

  depends_on = [
    module.acr,
    module.redis_cache
  ]
}

module "acr" {
  source = "./modules/acr"

  prefix                    = var.name_prefix
  acr_name                  = local.acr_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  resource_group_location   = azurerm_resource_group.resource_group.location
  acr_sku                   = var.acr_sku
  context_repo_path         = var.context_repo_path
  context_repo_access_token = var.git_pat
  git_pat                   = var.context_repo_access_token
  tags                      = var.tags
}
/*
data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks.name
  resource_group_name = module.aks.resource_group_name
}
*/
module "aks" {
  source = "./modules/aks"

  aks_name                = local.aks_name
  prefix                  = var.name_prefix
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_vault_id            = module.keyvault.key_vault_id
  acr_id                  = module.acr.acr_id
  tags                    = var.tags

  depends_on = [
    module.acr,
    module.redis_cache
  ]
}
/*
resource "azurerm_key_vault_access_policy" "aks_secrets_policy" {
  key_vault_id       = module.keyvault.key_vault_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = module.aks.secrets_provider_identity_object_id
  secret_permissions = ["Get", "List"]
}
*/
module "keyvault" {
  source = "./modules/keyvault"

  keyvault_name           = local.keyvault_name
  keyvault_sku_name       = var.keyvault_sku_name
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  tenant_id               = data.azurerm_client_config.current.tenant_id
  current_user_object_id  = data.azurerm_client_config.current.object_id
  tags                    = var.tags
}

module "redis_cache" {
  source = "./modules/redis"

  redis_name               = local.redis_name
  redis_sku_name           = var.redis_sku_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  resource_group_location  = azurerm_resource_group.resource_group.location
  key_vault_id             = module.keyvault.key_vault_id
  redis_hostname_secret    = var.redis_hostname_secret
  redis_primary_key_secret = var.redis_primary_key_secret
  create_redis_secrets     = true
  tags                     = var.tags

  depends_on = [
    module.keyvault
  ]
}

resource "kubectl_manifest" "secret-provider" {
  yaml_body = templatefile("./k8s-manifests/secret-provider.yaml.tftpl", {
    aks_kv_access_identity_id  = module.aks.aks_secret_provider_user_assigned_identity_id
    kv_name                    = module.keyvault.key_vault_name
    tenant_id                  = data.azurerm_client_config.current.tenant_id
    redis_url_secret_name      = var.redis_hostname_secret
    redis_password_secret_name = var.redis_primary_key_secret
  })

  depends_on = [
    module.keyvault,
    module.aks,
    module.redis_cache,
    module.acr
  ]
}

resource "kubectl_manifest" "deployment" {
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
  yaml_body = templatefile("./k8s-manifests/deployment.yaml.tftpl", {
    acr_login_server = module.acr.acr_login_server
    app_image_name   = "${var.name_prefix}-app"
    image_tag        = "latest"
  })

  depends_on = [
    kubectl_manifest.secret-provider
  ]
}

resource "kubectl_manifest" "service" {
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}"
      value_type = "regex"
    }
  }
  yaml_body = file("./k8s-manifests/service.yaml")

  depends_on = [
    kubectl_manifest.deployment
  ]
}

data "kubernetes_service" "service" {
  metadata {
    name      = "redis-flask-app-service"
    namespace = "default"
  }
  depends_on = [kubectl_manifest.service]
}

resource "azurerm_storage_account" "app_storage" {
  name                     = "stor${random_id.sa_suffix.hex}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "random_id" "sa_suffix" {
  byte_length = 4
}

resource "azurerm_storage_container" "app_container" {
  name                  = "app-blob-container"
  storage_account_name  = azurerm_storage_account.app_storage.name
  container_access_type = "blob"
}

resource "archive_file" "app_archive" {
  type        = "tar.gz"
  source_dir  = "${path.root}/application"
  output_path = "${path.root}/application.tar.gz"
}

resource "azurerm_storage_blob" "app_blob" {
  name                   = "application.tar.gz"
  storage_account_name   = azurerm_storage_account.app_storage.name
  storage_container_name = azurerm_storage_container.app_container.name
  type                   = "Block"
  source                 = archive_file.app_archive.output_path
}
