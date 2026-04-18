output "queue_url" {
  value = module.messaging.queue_url
}

output "network_arn" {
  value = module.networking.network_arn
}

output "cluster_endpoint" {
  value = length(module.kubernetes) > 0 ? module.kubernetes[0].cluster_endpoint : ""
}

output "db_endpoint" {
  value     = length(module.database_sql) > 0 ? module.database_sql[0].db_endpoint : ""
  sensitive = true
}
