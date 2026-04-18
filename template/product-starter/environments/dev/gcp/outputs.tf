output "queue_url" {
  description = "Pub/Sub subscription ID (the cross-cloud wire point for TASK_QUEUE_URL)."
  value       = length(module.messaging) > 0 ? module.messaging[0].queue_url : ""
}

output "network_arn" {
  description = "GCP VPC self_link."
  value       = module.networking.network_arn
}

output "cluster_endpoint" {
  description = "GKE API endpoint (empty when emulator_mode = true)."
  value       = length(module.kubernetes) > 0 ? module.kubernetes[0].cluster_endpoint : ""
}

output "db_endpoint" {
  description = "Cloud SQL connection name (empty when emulator_mode = true)."
  value       = length(module.database_sql) > 0 ? module.database_sql[0].db_endpoint : ""
  sensitive   = true
}
