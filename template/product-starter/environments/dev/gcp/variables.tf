variable "gcp_project" {
  type        = string
  description = "GCP project ID. Set via TF_VAR_gcp_project or CI secret."
  default     = ""
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "team" {
  type        = string
  default     = "trf"
  description = "Team name; combined with environment to form all resource names."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment label."
}

variable "owner" {
  type        = string
  default     = ""
  description = "Owning team or individual. Defaults to team when not set."
}

variable "vpc_cidr" {
  type    = string
  default = "10.3.0.0/16"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "emulator_mode" {
  type        = bool
  default     = false
  description = "When true, gates modules not covered by GCP emulators. GCP defaults to false — emulators cover Pub/Sub and Firestore only, not GKE or Cloud SQL."
}
