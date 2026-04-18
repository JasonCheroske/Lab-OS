output "bucket_name"   { value = google_storage_bucket.this.name }
output "bucket_arn"    { value = google_storage_bucket.this.id }
output "bucket_domain" { value = "https://storage.googleapis.com/${google_storage_bucket.this.name}" }
