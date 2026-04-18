# Interface: monitoring
variable "log_retention_days" { type = number; default = 30 }
variable "alarm_email"        { type = string; default = "" }
variable "team"               { type = string }
variable "environment"        { type = string }
variable "owner"              { type = string; default = "" }
variable "tags"               { type = map(string); default = {} }
