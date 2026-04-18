output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "Kubernetes API endpoint."
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Base64 CA data for kubeconfig."
  sensitive   = true
}

output "node_role_arn" {
  value       = aws_iam_role.node.arn
  description = "Worker node IAM role ARN."
}

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name."
}

output "oidc_issuer_url" {
  value       = try(aws_eks_cluster.this.identity[0].oidc[0].issuer, "")
  description = "OIDC issuer URL when available (for IRSA)."
}
