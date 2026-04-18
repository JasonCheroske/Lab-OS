variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "use_localstack" {
  type        = bool
  description = "Route AWS provider to LocalStack and use dummy credentials."
  default     = true
}

variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

variable "dev_state_bucket_name" {
  type    = string
  default = "tfstate-dev-local"
}

variable "prod_state_bucket_name" {
  type    = string
  default = "tfstate-prod-local"
}

variable "dev_lock_table_name" {
  type    = string
  default = "tflock-dev-local"
}

variable "prod_lock_table_name" {
  type    = string
  default = "tflock-prod-local"
}

variable "tags" {
  type    = map(string)
  default = {}
}
