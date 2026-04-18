locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "azurerm_container_registry" "this" {
  name                = replace("${local.name_prefix}acr", "-", "")
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = merge(local.common_tags, var.tags)
}
