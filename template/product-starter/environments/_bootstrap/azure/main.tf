resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.azure_location
  tags     = merge(var.tags, { Purpose = "terraform-state" })
}

resource "azurerm_storage_account" "dev" {
  name                     = var.storage_account_name_dev
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = var.azure_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = merge(var.tags, { Environment = "dev", Purpose = "terraform-state" })
}

resource "azurerm_storage_container" "dev" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.dev.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "prod" {
  name                     = var.storage_account_name_prod
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = var.azure_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = merge(var.tags, { Environment = "prod", Purpose = "terraform-state" })
}

resource "azurerm_storage_container" "prod" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.prod.name
  container_access_type = "private"
}
