# General
location    = "northeurope"
name_prefix = "cmtr-yurgas2r-mod8"
tags = {
  Creator = "sasa_filipovic@epam.com"
}

# ACI
aci_sku = "Standard"

# ACR 
context_repo_path         = "https://github.com/Shworc/Task08.git"
context_repo_access_token = "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"
git_pat                   = "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"
acr_sku                   = "Basic"

# KeyVault
keyvault_sku_name = "standard"

# Redis
redis_sku_name           = "Basic"
redis_hostname_secret    = "redis-hostname"
redis_primary_key_secret = "redis-primary-key"
