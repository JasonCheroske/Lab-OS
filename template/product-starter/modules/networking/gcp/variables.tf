variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR for the primary subnet."
}

variable "project" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "GCP region (e.g. us-central1)."
}

variable "azs" {
  type        = list(string)
  description = "GCP zones for subnet naming (e.g. [\"a\", \"b\"]). GCP VPCs are global; zones inform naming only."
  default     = ["a", "b"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create Cloud NAT for private subnet egress."
  default     = false
}

variable "team" {
  type        = string
  description = "Team name. Combined with environment to form all resource names."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc.)."
}

variable "owner" {
  type        = string
  description = "Owning team or individual. Defaults to team when not set."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional labels (GCP uses labels, not tags)."
  default     = {}
}
