variable "name"         { type = string; default = "" }
variable "scan_on_push" { type = bool; default = true }
variable "team"         { type = string }
variable "environment"  { type = string }
variable "owner"        { type = string; default = "" }
variable "tags"         { type = map(string); default = {} }
