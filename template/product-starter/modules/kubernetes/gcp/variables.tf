variable "project" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "GCP region."
}

variable "network_id" {
  type        = string
  description = "VPC network ID."
}

variable "subnet_id" {
  type        = string
  description = "Subnetwork ID for the node pool."
}

variable "cluster_version" {
  type    = string
  default = "latest"
}

variable "node_machine_type" {
  type    = string
  default = "e2-medium"
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
