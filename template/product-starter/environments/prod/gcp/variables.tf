variable "gcp_project" {
  type    = string
  default = ""
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "team" {
  type    = string
  default = "trf"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "owner" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = "10.13.0.0/16"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "emulator_mode" {
  type    = bool
  default = false
}
