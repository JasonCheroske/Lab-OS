variable "azure_location" {
  type    = string
  default = "eastus"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID. Required before running bootstrap."
  default     = ""
}

variable "resource_group_name" {
  type    = string
  default = "trf-tfstate-rg"
}

variable "storage_account_name_dev" {
  type        = string
  default     = "trfstatedev"
  description = "Must be globally unique, 3-24 chars, lowercase alphanumeric."
}

variable "storage_account_name_prod" {
  type        = string
  default     = "trfstateprod"
  description = "Must be globally unique, 3-24 chars, lowercase alphanumeric."
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "tags" {
  type    = map(string)
  default = {}
}
