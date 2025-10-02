locals {
  rg_name  = "${var.name_prefix}-rg"
  aci_name = "${var.name_prefix}-ci"
  acr_name = "${replace(var.name_prefix, "-", "")}cr"
  #acr_name                   = "${var.name_prefix}cr"
  aks_name                   = "${var.name_prefix}-aks"
  keyvault_name              = "${var.name_prefix}-kv"
  redis_name                 = "${var.name_prefix}-redis"
  safe_redis_hostname_secret = replace(var.redis_hostname_secret, "_", "-")
  redis_primary_key_secret   = replace(var.redis_hostname_secret, "_", "-")
}
