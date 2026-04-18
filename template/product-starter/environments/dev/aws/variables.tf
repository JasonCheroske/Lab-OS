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
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "db_username" {
  type    = string
  default = "applab"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Non-secret for LocalStack only; use Secrets Manager in real AWS."
}

variable "emulator_mode" {
  type        = bool
  default     = true
  description = "When true, gates out module calls that require real AWS credentials (EKS has no LocalStack emulation). AWS defaults to true — core modules work with LocalStack."
}
