# Interface: networking
# Variable-only stub — valid Terraform HCL. Output contract lives in contracts/networking.yaml.
# Every modules/networking/<cloud>/ implementation must declare these variables and expose
# all output keys listed in contracts/networking.yaml.

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block for the network."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones / zones (one public + one private subnet per zone)."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateway for private subnet egress."
  default     = false
}

variable "team" {
  type        = string
  description = "Team name. Used in name_prefix and Owner tag."
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
