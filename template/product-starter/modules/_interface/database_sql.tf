# Interface: database_sql
# Variable-only stub — valid Terraform HCL. Output contract lives in contracts/database_sql.yaml.

variable "vpc_id" {
  type        = string
  description = "VPC/network to place the database in."
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private subnets for the database."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDRs permitted to reach the DB port."
}

variable "engine" {
  type        = string
  description = "Database engine (postgres, mysql)."
  default     = "postgres"
}

variable "instance_class" {
  type        = string
  description = "Instance / SKU size."
}

variable "allocated_storage" {
  type        = number
  description = "Storage in GiB."
  default     = 20
}

variable "db_username" {
  type        = string
  description = "Master username."
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password. Use Secrets Manager / Key Vault in production."
}

variable "multi_az" {
  type        = bool
  description = "Enable high-availability / zone-redundant configuration."
  default     = false
}

variable "team" {
  type        = string
  description = "Team name."
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
  description = "Additional tags."
  default     = {}
}
