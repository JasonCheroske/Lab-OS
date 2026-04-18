# Interface: compute
variable "instance_type" { type = string }
variable "vpc_id"        { type = string }
variable "subnet_ids"    { type = list(string) }
variable "desired_count" { type = number; default = 1 }
variable "min_size"      { type = number; default = 1 }
variable "max_size"      { type = number; default = 3 }
variable "team"          { type = string }
variable "environment"   { type = string }
variable "owner"         { type = string; default = "" }
variable "tags"          { type = map(string); default = {} }
