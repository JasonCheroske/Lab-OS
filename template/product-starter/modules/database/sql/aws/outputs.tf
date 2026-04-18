output "db_endpoint" {
  value       = aws_db_instance.this.address
  description = "RDS hostname."
}

output "db_port" {
  value       = aws_db_instance.this.port
  description = "RDS port."
}

output "db_identifier" {
  value       = aws_db_instance.this.identifier
  description = "RDS instance identifier."
}
