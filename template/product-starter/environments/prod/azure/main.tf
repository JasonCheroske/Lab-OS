resource "azurerm_resource_group" "this" {
  name     = lower(format("%s-%s-rg", var.team, var.environment))
  location = var.azure_location
}

module "networking" {
  source = "../../../modules/networking/azure"

  cidr_block     = var.vpc_cidr
  location       = var.azure_location
  resource_group = azurerm_resource_group.this.name
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "messaging" {
  count  = var.emulator_mode ? 0 : 1
  source = "../../../modules/messaging/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "database_sql" {
  count  = var.emulator_mode ? 0 : 1
  source = "../../../modules/database/sql/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  subnet_id      = module.networking.private_subnet_ids[0]
  db_username    = var.db_username
  db_password    = var.db_password
  sku_name       = "GP_Standard_D4s_v3"
  high_available = true
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "kubernetes" {
  count  = var.emulator_mode ? 0 : 1
  source = "../../../modules/kubernetes/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  subnet_id      = module.networking.private_subnet_ids[0]
  node_vm_size   = "Standard_D4s_v3"
  node_count     = 3
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}
