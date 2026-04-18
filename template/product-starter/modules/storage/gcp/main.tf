locals {
  name_prefix   = lower(format("%s-%s", var.team, var.environment))
  common_labels = { environment = lower(var.environment); managed_by = lower(var.team); owner = lower(coalesce(var.owner, var.team)) }
}

resource "google_storage_bucket" "this" {
  name          = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-store"
  project       = var.project
  location      = upper(var.region)
  force_destroy = false
  labels        = local.common_labels

  versioning {
    enabled = var.versioning
  }

  uniform_bucket_level_access = true
}
