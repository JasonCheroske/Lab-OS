variable "vpc_id" {
  type = string
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private subnets for RDS."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDRs allowed to reach the DB port (use VPC CIDR or tighten to EKS SG in production)."
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "15.5"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "multi_az" {
  type    = bool
  default = false
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
