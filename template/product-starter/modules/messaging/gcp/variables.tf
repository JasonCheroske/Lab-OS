variable "project" {
  type = string
}

variable "max_receive_count" {
  type    = number
  default = 3
  description = "Dead-letter after this many undelivered attempts."
}

variable "retention_seconds" {
  type    = number
  default = 1209600
}

variable "team" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
