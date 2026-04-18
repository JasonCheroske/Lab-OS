locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "azurerm_servicebus_namespace" "this" {
  name                = "${local.name_prefix}-sbns"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"
  tags                = merge(local.common_tags, var.tags)
}

resource "azurerm_servicebus_queue" "dlq_source" {
  name         = "${local.name_prefix}-jobs"
  namespace_id = azurerm_servicebus_namespace.this.id

  dead_lettering_on_message_expiration = true
  max_delivery_count                   = var.max_receive_count
  default_message_ttl                  = "PT${var.retention_seconds}S"
}
