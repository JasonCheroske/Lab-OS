locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = "${local.name_prefix}-kv"
  location            = var.location
  resource_group_name = var.resource_group
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = merge(local.common_tags, var.tags)
}
