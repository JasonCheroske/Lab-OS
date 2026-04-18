output "db_endpoint" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "PostgreSQL Flexible Server hostname."
}

output "db_port" {
  value       = 5432
  description = "PostgreSQL port."
}

output "db_identifier" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "Server name."
}
