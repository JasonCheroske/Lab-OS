variable "resource_group" {
  type        = string
  description = "Azure resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the default node pool."
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "team" {
  type        = string
  description = "Team name."
}

variable "environment" {
  type        = string
  description = "Deployment environment."
}

variable "owner" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
