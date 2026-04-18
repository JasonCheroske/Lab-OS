locals {
  name_prefix   = lower(format("%s-%s", var.team, var.environment))
  common_labels = { environment = lower(var.environment); managed_by = lower(var.team); owner = lower(coalesce(var.owner, var.team)) }
}

resource "google_logging_project_bucket_config" "this" {
  project          = var.project
  location         = "global"
  retention_days   = var.log_retention_days
  bucket_id        = "${local.name_prefix}-logs"
  description      = "Log bucket for ${local.name_prefix}"
}
