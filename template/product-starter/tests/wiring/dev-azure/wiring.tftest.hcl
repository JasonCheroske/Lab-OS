# -----------------------------------------------------------------------
# Wiring tests — dev/azure
#
# Uses Terraform's native mock_provider (requires TF >= 1.7) to validate
# that module outputs flow correctly between modules and are exposed at
# the environment root — with zero Azure credentials or emulator required.
#
# Run: terraform test  (from this directory)
# -----------------------------------------------------------------------

mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg"
      name     = "trf-dev-rg"
      location = "eastus"
    }
  }

  mock_resource "azurerm_virtual_network" {
    defaults = {
      id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.Network/virtualNetworks/trf-dev-vnet"
      name          = "trf-dev-vnet"
      address_space = ["10.0.0.0/16"]
    }
  }

  mock_resource "azurerm_subnet" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.Network/virtualNetworks/trf-dev-vnet/subnets/trf-dev-subnet-0"
    }
  }

  mock_resource "azurerm_public_ip" {
    defaults = {
      id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.Network/publicIPAddresses/trf-dev-nat-pip"
      ip_address = "1.2.3.4"
    }
  }

  mock_resource "azurerm_nat_gateway" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.Network/natGateways/trf-dev-nat"
    }
  }

  mock_resource "azurerm_nat_gateway_public_ip_association" {
    defaults = { id = "nat-pip-association-wiring001" }
  }

  mock_resource "azurerm_subnet_nat_gateway_association" {
    defaults = { id = "subnet-nat-association-wiring001" }
  }

  mock_resource "azurerm_servicebus_namespace" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.ServiceBus/namespaces/trf-dev-sbns"
      name     = "trf-dev-sbns"
      endpoint = "https://trf-dev-sbns.servicebus.windows.net/"
    }
  }

  mock_resource "azurerm_servicebus_queue" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.ServiceBus/namespaces/trf-dev-sbns/queues/trf-dev-jobs"
      name = "trf-dev-jobs"
    }
  }

  mock_resource "azurerm_postgresql_flexible_server" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/trf-dev-psql"
      name = "trf-dev-psql"
      fqdn = "trf-dev-psql.postgres.database.azure.com"
    }
  }

  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/trf-dev-aks-identity"
      client_id    = "00000000-0000-0000-0000-000000000001"
      principal_id = "00000000-0000-0000-0000-000000000002"
    }
  }

  mock_resource "azurerm_kubernetes_cluster" {
    defaults = {
      id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/trf-dev-rg/providers/Microsoft.ContainerService/managedClusters/trf-dev-aks"
      name              = "trf-dev-aks"
      oidc_issuer_url   = "https://eastus.oic.prod-aks.azure.com/mock/"
      kube_config = [{
        host                   = "https://trf-dev-aks.hcp.eastus.azmk8s.io"
        cluster_ca_certificate = "bW9jaw=="
        client_certificate     = ""
        client_key             = ""
        username               = ""
        password               = ""
      }]
    }
  }
}

# -----------------------------------------------------------------------
# Test: Networking outputs are well-formed
# -----------------------------------------------------------------------

run "networking_outputs_are_populated" {
  assert {
    condition     = length(module.networking.vpc_id) > 0
    error_message = "networking.vpc_id is empty"
  }

  assert {
    condition     = length(module.networking.private_subnet_ids) > 0
    error_message = "networking.private_subnet_ids is empty"
  }

  assert {
    condition     = module.networking.cidr_block == var.vpc_cidr
    error_message = "networking.cidr_block does not match input vpc_cidr — variable not threaded through"
  }
}

run "network_arn_is_arm_resource_id" {
  assert {
    condition     = startswith(module.networking.network_arn, "/subscriptions/")
    error_message = "network_arn does not start with '/subscriptions/' — Azure ARM ID format broken"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Database wiring
# -----------------------------------------------------------------------

run "database_receives_subnet_from_networking" {
  assert {
    condition     = length(module.database_sql.db_endpoint) > 0
    error_message = "database_sql.db_endpoint is empty — db module failed to apply, likely subnet wiring error"
  }

  assert {
    condition     = module.database_sql.db_port == 5432
    error_message = "database_sql.db_port is not 5432"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Kubernetes wiring
# -----------------------------------------------------------------------

run "kubernetes_receives_subnet_from_networking" {
  assert {
    condition     = length(module.kubernetes.cluster_endpoint) > 0
    error_message = "kubernetes.cluster_endpoint is empty — k8s module failed to apply, likely subnet wiring error"
  }

  assert {
    condition     = startswith(module.kubernetes.cluster_endpoint, "https://")
    error_message = "kubernetes.cluster_endpoint does not start with 'https://'"
  }
}

# -----------------------------------------------------------------------
# Test: Messaging outputs are present
# -----------------------------------------------------------------------

run "messaging_outputs_are_populated" {
  assert {
    condition     = length(module.messaging.queue_url) > 0
    error_message = "messaging.queue_url is empty"
  }

  assert {
    condition     = length(module.messaging.dlq_url) > 0
    error_message = "messaging.dlq_url is empty — dead-letter path missing"
  }
}

# -----------------------------------------------------------------------
# Test: Environment root outputs are all exposed
# -----------------------------------------------------------------------

run "environment_root_outputs_complete" {
  assert {
    condition     = length(output.queue_url) > 0
    error_message = "queue_url not exposed at environment root"
  }

  assert {
    condition     = length(output.network_arn) > 0
    error_message = "network_arn not exposed at environment root"
  }

  assert {
    condition     = length(output.cluster_endpoint) > 0
    error_message = "cluster_endpoint not exposed at environment root"
  }
}
