output "db_endpoint" {
  value       = google_sql_database_instance.this.private_ip_address
  description = "Cloud SQL private IP address."
}

output "db_port" {
  value       = 5432
  description = "PostgreSQL port."
}

output "db_identifier" {
  value       = google_sql_database_instance.this.connection_name
  description = "Cloud SQL connection name (project:region:instance)."
}
