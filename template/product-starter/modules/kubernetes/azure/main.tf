locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "${local.name_prefix}-aks-identity"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = merge(local.common_tags, var.tags)
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${local.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${local.name_prefix}-aks"
  kubernetes_version  = var.cluster_version

  default_node_pool {
    name                = "default"
    vm_size             = var.node_vm_size
    node_count          = var.node_count
    min_count           = var.node_min_size
    max_count           = var.node_max_size
    enable_auto_scaling = true
    vnet_subnet_id      = var.subnet_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }

  tags = merge(local.common_tags, var.tags)
}
