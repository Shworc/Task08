resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = var.acr_sku
  admin_enabled       = true

  tags = var.tags
}

resource "azurerm_container_registry_task" "build_docker_image" {
  name                  = "${var.prefix}-acr-registry-task"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    #dockerfile_path = "${path.root}/task08/application/Dockerfile"
    dockerfile_path = "task08/application/Dockerfile"
    context_path    = "https://github.com/Shworc/Task08.git"
    #context_access_token = var.context_repo_access_token
    context_access_token = var.git_pat
    image_names          = ["${var.prefix}-app:latest"]
    push_enabled         = true
  }
  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_container_registry_task_schedule_run_now" "run_build_docker_image" {
  container_registry_task_id = azurerm_container_registry_task.build_docker_image.id
  depends_on = [
    azurerm_container_registry_task.build_docker_image
  ]
}



