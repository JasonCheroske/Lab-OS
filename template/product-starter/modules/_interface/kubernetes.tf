# Interface: kubernetes
# Variable-only stub — valid Terraform HCL. Output contract lives in contracts/kubernetes.yaml.

variable "cluster_version" {
  type        = string
  description = "Kubernetes version."
  default     = "1.29"
}

variable "vpc_id" {
  type        = string
  description = "Network/VPC ID to place the cluster in."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for control plane configuration."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for node groups / node pools."
}

variable "node_instance_types" {
  type        = list(string)
  description = "Node instance type(s)."
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  type        = number
  description = "Initial desired node count (autoscaler will override after first apply)."
  default     = 2
}

variable "node_min_size" {
  type        = number
  description = "Minimum node count."
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum node count."
  default     = 4
}

variable "endpoint_public_access" {
  type        = bool
  description = "Allow public API server endpoint access."
  default     = true
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
