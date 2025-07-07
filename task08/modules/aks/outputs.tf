output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "The FQDN for the Azure Kubernetes Service."
}

output "aks_id" {
  description = "The ID of azure kubernetes service"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "kube_config_host" {
  description = "The host URL for the Kubernetes cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "kube_config_client_certificate" {
  description = "The client certificate for the Kubernetes cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
}

output "kube_config_client_key" {
  description = "The client key for the Kubernetes cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
}

output "kube_config_cluster_ca_certificate" {
  description = "The cluster CA certificate for the Kubernetes cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}
/*
output "aks_secret_provider_user_assigned_identity_id" {
  description = "The user assigned identity id for cluster secret provider"
  value       = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}

output "agent_pool_client_id" {
  value = var.agent_pool_client_id
}

/*
output "agent_pool_client_id" {
  value = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

output "kubelet_identity_object_id" {
  #value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}
*/
output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "agent_pool_client_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

output "name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "secrets_provider_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "aks_secret_provider_user_assigned_identity_id" {
  description = "The user assigned identity id for cluster secret provider"
  value       = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}