output "vpc_id" {
  value = module.networking.vpc_id
}

output "network_arn" {
  value = module.networking.network_arn
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "cidr_block" {
  value = module.networking.cidr_block
}

output "queue_url" {
  value = module.messaging.queue_url
}

output "queue_arn" {
  value = module.messaging.queue_arn
}

output "dlq_url" {
  value = module.messaging.dlq_url
}

output "db_endpoint" {
  value     = module.database_sql.db_endpoint
  sensitive = true
}

output "cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}

output "cluster_name" {
  value = module.kubernetes.cluster_name
}
