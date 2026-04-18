variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "use_localstack" {
  type    = bool
  default = true
}

variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

variable "team" {
  type        = string
  default     = "trf"
  description = "Team name; combined with environment to form all resource names."
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Deployment environment label."
}

variable "owner" {
  type        = string
  default     = ""
  description = "Owning team or individual. Defaults to team when not set."
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "db_username" {
  type    = string
  default = "applab"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Use Secrets Manager + TF_VAR_ in real prod; placeholder for scaffold."
}

variable "emulator_mode" {
  type        = bool
  default     = true
  description = "When true, gates out module calls that require real AWS credentials. AWS defaults to true for study; set false for real cloud apply."
}
