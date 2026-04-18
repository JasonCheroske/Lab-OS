# -----------------------------------------------------------------------
# Wiring tests — dev/gcp
#
# Uses Terraform's native mock_provider (requires TF >= 1.7) to validate
# that module outputs flow correctly between modules and are exposed at
# the environment root — with zero GCP credentials or emulator required.
#
# Run: terraform test  (from this directory)
# -----------------------------------------------------------------------

mock_provider "google" {
  mock_resource "google_compute_network" {
    defaults = {
      id        = "projects/trf-dev-project/global/networks/trf-dev-vpc"
      name      = "trf-dev-vpc"
      self_link = "https://www.googleapis.com/compute/v1/projects/trf-dev-project/global/networks/trf-dev-vpc"
    }
  }

  mock_resource "google_compute_subnetwork" {
    defaults = {
      id        = "projects/trf-dev-project/regions/us-central1/subnetworks/trf-dev-subnet-0"
      self_link = "https://www.googleapis.com/compute/v1/projects/trf-dev-project/regions/us-central1/subnetworks/trf-dev-subnet-0"
    }
  }

  mock_resource "google_compute_router" {
    defaults = {
      id   = "projects/trf-dev-project/regions/us-central1/routers/trf-dev-router"
      name = "trf-dev-router"
    }
  }

  mock_resource "google_compute_router_nat" {
    defaults = { id = "trf-dev-project/us-central1/trf-dev-router/trf-dev-nat" }
  }

  mock_resource "google_pubsub_topic" {
    defaults = {
      id   = "projects/trf-dev-project/topics/trf-dev-jobs"
      name = "trf-dev-jobs"
    }
  }

  mock_resource "google_pubsub_subscription" {
    defaults = {
      id   = "projects/trf-dev-project/subscriptions/trf-dev-jobs-sub"
      name = "trf-dev-jobs-sub"
    }
  }

  mock_resource "google_sql_database_instance" {
    defaults = {
      id                 = "trf-dev-sql"
      name               = "trf-dev-sql"
      connection_name    = "trf-dev-project:us-central1:trf-dev-sql"
      private_ip_address = "10.0.100.10"
    }
  }

  mock_resource "google_sql_user" {
    defaults = { id = "trf-dev-sql/trf_dev_user" }
  }

  mock_resource "google_container_cluster" {
    defaults = {
      id       = "projects/trf-dev-project/locations/us-central1/clusters/trf-dev-gke"
      name     = "trf-dev-gke"
      endpoint = "10.0.200.10"
      master_auth = [{
        cluster_ca_certificate = "bW9jaw=="
        client_certificate     = ""
        client_key             = ""
      }]
      identity = [{ workload_identity_config = [] }]
    }
  }

  mock_resource "google_container_node_pool" {
    defaults = {
      id   = "projects/trf-dev-project/locations/us-central1/clusters/trf-dev-gke/nodePools/trf-dev-ng"
      name = "trf-dev-ng"
      node_config = [{
        service_account = "default-sa@trf-dev-project.iam.gserviceaccount.com"
        labels          = {}
        machine_type    = "e2-medium"
        disk_size_gb    = 100
        disk_type       = "pd-standard"
        image_type      = "COS_CONTAINERD"
        oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
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

run "network_arn_is_gcp_self_link" {
  assert {
    condition     = startswith(module.networking.network_arn, "https://www.googleapis.com/")
    error_message = "network_arn does not start with GCP self_link URL prefix"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Database wiring
# -----------------------------------------------------------------------

run "database_receives_network_id_from_networking" {
  assert {
    condition     = length(module.database_sql.db_endpoint) > 0
    error_message = "database_sql.db_endpoint is empty — db module failed to apply, likely network_id wiring error"
  }

  assert {
    condition     = length(module.database_sql.db_identifier) > 0
    error_message = "database_sql.db_identifier is empty — Cloud SQL connection_name not set"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Kubernetes wiring
# -----------------------------------------------------------------------

run "kubernetes_receives_network_from_networking" {
  assert {
    condition     = length(module.kubernetes.cluster_endpoint) > 0
    error_message = "kubernetes.cluster_endpoint is empty — k8s module failed to apply, likely network wiring error"
  }

  assert {
    condition     = startswith(module.kubernetes.cluster_endpoint, "https://")
    error_message = "kubernetes.cluster_endpoint does not start with 'https://' — GKE endpoint construction broken"
  }
}

# -----------------------------------------------------------------------
# Test: Messaging outputs are present
# -----------------------------------------------------------------------

run "messaging_outputs_are_populated" {
  assert {
    condition     = length(module.messaging.queue_url) > 0
    error_message = "messaging.queue_url is empty — Pub/Sub subscription ID missing"
  }

  assert {
    condition     = length(module.messaging.dlq_url) > 0
    error_message = "messaging.dlq_url is empty — dead-letter topic ID missing"
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
