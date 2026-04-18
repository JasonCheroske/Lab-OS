variable "cidr_block" {
  type        = string
  description = "IPv4 address space for the VNet."
}

variable "location" {
  type        = string
  description = "Azure region (e.g. eastus)."
}

variable "resource_group" {
  type        = string
  description = "Azure resource group name."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for subnet distribution (e.g. [\"1\", \"2\"])."
  default     = ["1", "2"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Attach a NAT gateway to private subnets."
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
  description = "Additional tags merged on top of common_tags."
  default     = {}
}
