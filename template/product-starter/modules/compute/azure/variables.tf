variable "instance_type" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "team" { type = string }
variable "environment" { type = string }
variable "owner" { type = string; default = "" }
variable "tags" { type = map(string); default = {} }
