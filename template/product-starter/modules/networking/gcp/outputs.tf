output "vpc_id" {
  value       = google_compute_network.this.id
  description = "VPC network ID."
}

output "public_subnet_ids" {
  value       = google_compute_subnetwork.public[*].id
  description = "Public subnetwork IDs."
}

output "private_subnet_ids" {
  value       = google_compute_subnetwork.private[*].id
  description = "Private subnetwork IDs."
}

output "cidr_block" {
  value       = var.cidr_block
  description = "Primary subnet CIDR (for firewall rule scoping)."
}

output "network_arn" {
  value       = google_compute_network.this.self_link
  description = "Globally unique resource identifier for the network. For GCP this is the self_link URL."
}
