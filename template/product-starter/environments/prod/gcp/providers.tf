provider "google" {
  project = var.gcp_project != "" ? var.gcp_project : null
  region  = var.gcp_region
}
