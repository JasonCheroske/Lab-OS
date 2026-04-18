variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR for the VPC."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones (one public + one private subnet per AZ)."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateway(s) and private subnet default route (cost driver when true)."
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
