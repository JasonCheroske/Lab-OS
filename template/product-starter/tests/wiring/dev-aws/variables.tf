variable "team" {
  type    = string
  default = "trf"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
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
  type    = string
  default = "test-only-not-real"
}
