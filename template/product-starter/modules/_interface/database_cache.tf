# Interface: database_cache
variable "node_type"    { type = string }
variable "replicas"     { type = number; default = 0 }
variable "team"         { type = string }
variable "environment"  { type = string }
variable "owner"        { type = string; default = "" }
variable "tags"         { type = map(string); default = {} }
