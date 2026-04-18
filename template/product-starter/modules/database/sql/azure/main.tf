locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "${local.name_prefix}-psql"
  resource_group_name    = var.resource_group
  location               = var.location
  version                = "15"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = var.sku_name
  storage_mb             = 32768
  delegated_subnet_id    = var.subnet_id
  backup_retention_days  = 7

  dynamic "high_availability" {
    for_each = var.high_available ? [1] : []
    content {
      mode = "ZoneRedundant"
    }
  }

  tags = merge(local.common_tags, var.tags)
}
