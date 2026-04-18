locals {
  name_prefix   = lower(format("%s-%s", var.team, var.environment))
  common_labels = { environment = lower(var.environment); managed_by = lower(var.team); owner = lower(coalesce(var.owner, var.team)) }
}

resource "google_secret_manager_secret" "this" {
  secret_id = var.secret_name != "" ? var.secret_name : "${local.name_prefix}-secret"
  project   = var.project
  labels    = local.common_labels

  replication {
    auto {}
  }
}
