locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = [var.cidr_block]
  tags                = merge(local.common_tags, var.tags)
}

resource "azurerm_subnet" "public" {
  count                = length(var.azs)
  name                 = "${local.name_prefix}-public-${count.index}"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.cidr_block, 8, count.index)]
}

resource "azurerm_subnet" "private" {
  count                = length(var.azs)
  name                 = "${local.name_prefix}-private-${count.index}"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.cidr_block, 8, count.index + 10)]
}

resource "azurerm_public_ip" "nat" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${local.name_prefix}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge(local.common_tags, var.tags)
}

resource "azurerm_nat_gateway" "this" {
  count               = var.enable_nat_gateway ? 1 : 0
  name                = "${local.name_prefix}-nat"
  location            = var.location
  resource_group_name = var.resource_group
  sku_name            = "Standard"
  tags                = merge(local.common_tags, var.tags)
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count                = var.enable_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = var.enable_nat_gateway ? length(var.azs) : 0
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}
