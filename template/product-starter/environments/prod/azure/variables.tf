variable "azure_location" {
  type    = string
  default = "eastus"
}

variable "subscription_id" {
  type    = string
  default = ""
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
  default = "10.12.0.0/16"
}

variable "db_username" {
  type    = string
  default = "applab"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "emulator_mode" {
  type    = bool
  default = false
}
