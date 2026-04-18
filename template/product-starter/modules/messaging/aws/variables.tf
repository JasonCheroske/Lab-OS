variable "max_receive_count" {
  type        = number
  description = "Redrive threshold (three-strike policy = 3)."
  default     = 3
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout for the primary queue."
  default     = 30
}

variable "retention_seconds" {
  type        = number
  description = "Message retention period in seconds."
  default     = 1209600
}

variable "team" {
  type        = string
  description = "Team name. Combined with environment to form queue name and resource tags."
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
  description = "Additional tags merged on top of common_tags."
  default     = {}
}
