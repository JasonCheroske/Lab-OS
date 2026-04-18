variable "azure_location" {
  type        = string
  default     = "eastus"
  description = "Azure region for all resources."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID. Set via TF_VAR_subscription_id or CI secret."
  default     = ""
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
  default = "10.2.0.0/16"
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
  type        = bool
  default     = false
  description = "When true, gates modules not covered by Azurite. Azure defaults to false — Azurite covers storage only, not AKS/PostgreSQL/Service Bus."
}
