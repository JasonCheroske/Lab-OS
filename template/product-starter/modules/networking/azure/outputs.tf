output "vpc_id" {
  value       = azurerm_virtual_network.this.id
  description = "VNet resource ID."
}

output "public_subnet_ids" {
  value       = azurerm_subnet.public[*].id
  description = "Public subnet IDs."
}

output "private_subnet_ids" {
  value       = azurerm_subnet.private[*].id
  description = "Private subnet IDs."
}

output "cidr_block" {
  value       = azurerm_virtual_network.this.address_space[0]
  description = "VNet address space (for security rule scoping)."
}

output "network_arn" {
  value       = azurerm_virtual_network.this.id
  description = "Globally unique resource identifier for the network. For Azure this is the ARM resource ID."
}
