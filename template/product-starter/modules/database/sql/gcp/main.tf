locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_labels = {
    environment = lower(var.environment)
    managed_by  = lower(var.team)
    owner       = lower(coalesce(var.owner, var.team))
  }
}

resource "google_sql_database_instance" "this" {
  name             = "${local.name_prefix}-sql"
  project          = var.project
  region           = var.region
  database_version = "POSTGRES_15"

  settings {
    tier              = var.tier
    availability_type = var.availability_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    user_labels = local.common_labels
  }

  deletion_protection = false
}

resource "google_sql_user" "this" {
  name     = lower(format("%s_%s_user", var.team, var.environment))
  project  = var.project
  instance = google_sql_database_instance.this.name
  password = var.db_password
}
