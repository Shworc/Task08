output "aci_fqdn" {
  description = "The FQDN for the Azure Container Instance"
  value       = azurerm_container_group.aci.fqdn
}
output "aci_id" {
  description = "Azure Container Instance ID"
  value       = azurerm_container_group.aci.id
}
