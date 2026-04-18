variable "node_type" { type = string }
variable "team" { type = string }
variable "environment" { type = string }
variable "owner" { type = string; default = "" }
variable "tags" { type = map(string); default = {} }
