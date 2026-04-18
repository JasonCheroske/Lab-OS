variable "gcp_project" {
  type        = string
  description = "GCP project ID. Must be set before running bootstrap."
}

variable "gcp_region" {
  type    = string
  default = "US"
  description = "Multi-region location for GCS bucket (US, EU, ASIA) or regional (e.g. us-central1)."
}

variable "dev_bucket_name" {
  type        = string
  default     = "trf-tfstate-dev"
  description = "GCS bucket for dev state. Must be globally unique."
}

variable "prod_bucket_name" {
  type        = string
  default     = "trf-tfstate-prod"
  description = "GCS bucket for prod state. Must be globally unique."
}

variable "labels" {
  type    = map(string)
  default = {}
}
