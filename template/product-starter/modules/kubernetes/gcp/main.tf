locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_labels = {
    environment = lower(var.environment)
    managed_by  = lower(var.team)
    owner       = lower(coalesce(var.owner, var.team))
  }
}

resource "google_container_cluster" "this" {
  name     = "${local.name_prefix}-gke"
  project  = var.project
  location = var.region
  network  = var.network_id
  subnetwork = var.subnet_id

  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = var.cluster_version == "latest" ? null : var.cluster_version

  resource_labels = local.common_labels
}

resource "google_container_node_pool" "this" {
  name     = "${local.name_prefix}-ng"
  project  = var.project
  location = var.region
  cluster  = google_container_cluster.this.name

  initial_node_count = var.node_count

  autoscaling {
    min_node_count = var.node_min_size
    max_node_count = var.node_max_size
  }

  node_config {
    machine_type = var.node_machine_type
    labels       = local.common_labels
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }
}
