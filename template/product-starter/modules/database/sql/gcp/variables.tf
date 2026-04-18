variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "network_id" {
  type        = string
  description = "VPC network ID for private IP."
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
