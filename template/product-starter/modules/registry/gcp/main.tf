locals {
  name_prefix   = lower(format("%s-%s", var.team, var.environment))
  common_labels = { environment = lower(var.environment); managed_by = lower(var.team); owner = lower(coalesce(var.owner, var.team)) }
}

resource "google_artifact_registry_repository" "this" {
  provider      = google
  location      = var.region
  project       = var.project
  repository_id = var.name != "" ? var.name : "${local.name_prefix}-registry"
  format        = "DOCKER"
  labels        = local.common_labels
}
