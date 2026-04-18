# Interface: messaging
# Variable-only stub — valid Terraform HCL. Output contract lives in contracts/messaging.yaml.

variable "max_receive_count" {
  type        = number
  description = "Redrive / dead-letter threshold (three-strike policy = 3)."
  default     = 3
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Message visibility timeout in seconds."
  default     = 30
}

variable "retention_seconds" {
  type        = number
  description = "Message retention period in seconds (default 14 days)."
  default     = 1209600
}

variable "team" {
  type        = string
  description = "Team name."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc.)."
}

variable "owner" {
  type        = string
  description = "Owning team or individual. Defaults to team when not set."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional tags."
  default     = {}
}
