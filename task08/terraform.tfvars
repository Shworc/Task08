# General
location    = "westeurope"
name_prefix = "cmtr-yurgas2r-mod8"
tags = {
  Creator = "sasa_filipovic@epam.com"
}

# ACI
aci_sku = "Standard"

# ACR 
# context_repo_path = "https://github.com/Shworc/Task08.git"
context_repo_access_token = "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"
acr_sku = "Basic"

# KeyVault
keyvault_sku_name = "${keyvault_sku}"

# Redis
redis_sku_name           = "${redis_sku}"
redis_hostname_secret    = "${redis_hostname}"
redis_primary_key_secret = "${redis_primary_key}"
