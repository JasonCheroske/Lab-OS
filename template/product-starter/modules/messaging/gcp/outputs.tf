output "queue_url" {
  value       = google_pubsub_subscription.this.id
  description = "Pub/Sub subscription ID (inject as TASK_QUEUE_URL)."
}

output "queue_arn" {
  value       = google_pubsub_topic.this.id
  description = "Pub/Sub topic resource name."
}

output "dlq_url" {
  value       = google_pubsub_topic.dlq.id
  description = "Dead-letter topic resource name."
}

output "dlq_arn" {
  value       = google_pubsub_topic.dlq.id
  description = "Dead-letter topic resource name."
}
