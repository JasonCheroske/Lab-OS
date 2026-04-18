locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_labels = {
    environment = lower(var.environment)
    managed_by  = lower(var.team)
    owner       = lower(coalesce(var.owner, var.team))
  }
}

resource "google_compute_network" "this" {
  name                    = "${local.name_prefix}-vpc"
  project                 = var.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  count         = length(var.azs)
  name          = "${local.name_prefix}-public-${count.index}"
  project       = var.project
  region        = var.region
  network       = google_compute_network.this.id
  ip_cidr_range = cidrsubnet(var.cidr_block, 8, count.index)
}

resource "google_compute_subnetwork" "private" {
  count                    = length(var.azs)
  name                     = "${local.name_prefix}-private-${count.index}"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = cidrsubnet(var.cidr_block, 8, count.index + 10)
  private_ip_google_access = true
}

resource "google_compute_router" "this" {
  count   = var.enable_nat_gateway ? 1 : 0
  name    = "${local.name_prefix}-router"
  project = var.project
  region  = var.region
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  count                              = var.enable_nat_gateway ? 1 : 0
  name                               = "${local.name_prefix}-nat"
  project                            = var.project
  router                             = google_compute_router.this[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private
    content {
      name                    = subnetwork.value.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}
