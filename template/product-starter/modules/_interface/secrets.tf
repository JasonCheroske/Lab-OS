# Interface: secrets
variable "secret_name"    { type = string }
variable "rotation_days"  { type = number; default = 0 }
variable "team"           { type = string }
variable "environment"    { type = string }
variable "owner"          { type = string; default = "" }
variable "tags"           { type = map(string); default = {} }
