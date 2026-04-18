provider "google" {
  project = var.gcp_project != "" ? var.gcp_project : null
  region  = var.gcp_region
  # Credentials: use Application Default Credentials (gcloud auth application-default login)
  # or set GOOGLE_APPLICATION_CREDENTIALS to a service account key path.
}
