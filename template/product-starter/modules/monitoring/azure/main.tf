locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${local.name_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = merge(local.common_tags, var.tags)
}
