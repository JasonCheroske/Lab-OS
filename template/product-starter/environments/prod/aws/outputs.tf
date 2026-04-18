output "queue_url" {
  description = "Primary SQS URL — wire into EKS via ConfigMap/Helm/external secrets."
  value       = module.messaging.queue_url
}

output "network_arn" {
  description = "Constructed VPC ARN for this environment."
  value       = module.networking.network_arn
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint (empty when emulator_mode = true)."
  value       = length(module.kubernetes) > 0 ? module.kubernetes[0].cluster_endpoint : ""
}

output "db_endpoint" {
  description = "RDS hostname."
  value       = module.database_sql.db_endpoint
  sensitive   = true
}
