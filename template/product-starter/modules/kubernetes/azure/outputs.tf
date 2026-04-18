output "cluster_endpoint" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
  description = "AKS API server endpoint."
}

output "cluster_certificate_authority_data" {
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  description = "Base64 CA certificate for kubeconfig."
  sensitive   = true
}

output "node_role_arn" {
  value       = azurerm_user_assigned_identity.aks.principal_id
  description = "Managed identity principal ID (AKS node identity)."
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "AKS cluster name."
}

output "oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
  description = "OIDC issuer URL for workload identity."
}
