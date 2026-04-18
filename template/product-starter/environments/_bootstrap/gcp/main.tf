resource "google_storage_bucket" "dev" {
  name          = var.dev_bucket_name
  project       = var.gcp_project
  location      = var.gcp_region
  force_destroy = false
  labels        = merge(var.labels, { environment = "dev", purpose = "terraform-state" })

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "prod" {
  name          = var.prod_bucket_name
  project       = var.gcp_project
  location      = var.gcp_region
  force_destroy = false
  labels        = merge(var.labels, { environment = "prod", purpose = "terraform-state" })

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}
