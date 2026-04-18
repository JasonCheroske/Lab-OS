# Interface: serverless
variable "function_name" { type = string }
variable "runtime"       { type = string }
variable "handler"       { type = string; default = "index.handler" }
variable "memory_mb"     { type = number; default = 256 }
variable "timeout_s"     { type = number; default = 30 }
variable "team"          { type = string }
variable "environment"   { type = string }
variable "owner"         { type = string; default = "" }
variable "tags"          { type = map(string); default = {} }
