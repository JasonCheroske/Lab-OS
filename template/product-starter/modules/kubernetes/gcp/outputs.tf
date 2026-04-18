output "cluster_endpoint" {
  value       = "https://${google_container_cluster.this.endpoint}"
  description = "GKE master endpoint."
}

output "cluster_certificate_authority_data" {
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  description = "Base64 CA certificate for kubeconfig."
  sensitive   = true
}

output "node_role_arn" {
  value       = google_container_node_pool.this.node_config[0].service_account
  description = "Service account email used by cluster nodes."
}

output "cluster_name" {
  value       = google_container_cluster.this.name
  description = "GKE cluster name."
}

output "oidc_issuer_url" {
  value       = "https://container.googleapis.com/v1/projects/${var.project}/locations/${var.region}/clusters/${google_container_cluster.this.name}"
  description = "Workload Identity issuer URL."
}
