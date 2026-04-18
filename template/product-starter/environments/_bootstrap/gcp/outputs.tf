output "dev_bucket" {
  value = google_storage_bucket.dev.name
}

output "prod_bucket" {
  value = google_storage_bucket.prod.name
}
