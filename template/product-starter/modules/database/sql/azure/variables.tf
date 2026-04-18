variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Delegated subnet for private endpoint."
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "high_available" {
  type    = bool
  default = false
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
