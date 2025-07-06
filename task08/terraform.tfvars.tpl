# General
location    = "East US"
name_prefix = "${resources_name_prefix}"
tags = {
  Creator = "${student_email}"
}

# ACI
aci_sku = "${aci_sku}"

# ACR 
# context_repo_path = "https://github.com/<username>/<repository>#task08/application"
acr_sku = "${acr_sku}"

# KeyVault
keyvault_sku_name = "${keyvault_sku}"

# Redis
redis_sku_name           = "${redis_sku}"
redis_hostname_secret    = "${redis_hostname}"
redis_primary_key_secret = "${redis_primary_key}"

