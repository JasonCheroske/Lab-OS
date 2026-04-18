locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "azurerm_storage_account" "this" {
  name                     = replace("${local.name_prefix}store", "-", "")
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = var.versioning
  }

  tags = merge(local.common_tags, var.tags)
}

resource "azurerm_storage_container" "this" {
  name                  = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-store"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
