output "log_group_name" { value = google_logging_project_bucket_config.this.bucket_id }
output "log_group_arn"  { value = google_logging_project_bucket_config.this.id }
