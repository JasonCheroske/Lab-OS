variable "bucket_name" { type = string; default = "" }
variable "versioning"  { type = bool; default = true }
variable "encryption"  { type = bool; default = true }
variable "team"        { type = string }
variable "environment" { type = string }
variable "owner"       { type = string; default = "" }
variable "tags"        { type = map(string); default = {} }
