locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_labels = {
    environment = lower(var.environment)
    managed_by  = lower(var.team)
    owner       = lower(coalesce(var.owner, var.team))
  }
}

resource "google_pubsub_topic" "dlq" {
  name    = "${local.name_prefix}-jobs-dlq"
  project = var.project
  labels  = local.common_labels
}

resource "google_pubsub_topic" "this" {
  name    = "${local.name_prefix}-jobs"
  project = var.project
  labels  = local.common_labels
}

resource "google_pubsub_subscription" "this" {
  name    = "${local.name_prefix}-jobs-sub"
  project = var.project
  topic   = google_pubsub_topic.this.id

  message_retention_duration = "${var.retention_seconds}s"
  ack_deadline_seconds       = 30

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dlq.id
    max_delivery_attempts = var.max_receive_count
  }

  labels = local.common_labels
}
