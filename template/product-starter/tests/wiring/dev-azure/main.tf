# Wiring test configuration for dev/azure.
# Mirrors environments/dev/azure/main.tf without emulator_mode gating
# so all module connections are exercised by the mock provider.

resource "azurerm_resource_group" "this" {
  name     = lower(format("%s-%s-rg", var.team, var.environment))
  location = var.azure_location
}

module "networking" {
  source = "../../../modules/networking/azure"

  cidr_block         = var.vpc_cidr
  azs                = var.azs
  location           = var.azure_location
  resource_group     = azurerm_resource_group.this.name
  enable_nat_gateway = var.enable_nat_gateway
  team               = var.team
  environment        = var.environment
  owner              = var.owner
}

module "messaging" {
  source = "../../../modules/messaging/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "database_sql" {
  source = "../../../modules/database/sql/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  subnet_id      = module.networking.private_subnet_ids[0]
  db_username    = var.db_username
  db_password    = var.db_password
  sku_name       = "B_Standard_B1ms"
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}

module "kubernetes" {
  source = "../../../modules/kubernetes/azure"

  resource_group = azurerm_resource_group.this.name
  location       = var.azure_location
  subnet_id      = module.networking.private_subnet_ids[0]
  node_vm_size   = "Standard_B2s"
  node_count     = 1
  team           = var.team
  environment    = var.environment
  owner          = var.owner
}
