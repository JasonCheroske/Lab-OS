output "queue_url" {
  description = "Service Bus queue connection string (empty when emulator_mode = true)."
  value       = length(module.messaging) > 0 ? module.messaging[0].queue_url : ""
}

output "network_arn" {
  description = "Azure VNet ARM resource ID."
  value       = module.networking.network_arn
}

output "cluster_endpoint" {
  description = "AKS API endpoint (empty when emulator_mode = true)."
  value       = length(module.kubernetes) > 0 ? module.kubernetes[0].cluster_endpoint : ""
}

output "db_endpoint" {
  description = "PostgreSQL Flexible Server hostname (empty when emulator_mode = true)."
  value       = length(module.database_sql) > 0 ? module.database_sql[0].db_endpoint : ""
  sensitive   = true
}
