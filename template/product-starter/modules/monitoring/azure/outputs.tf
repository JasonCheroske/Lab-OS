output "log_group_name" { value = azurerm_log_analytics_workspace.this.name }
output "log_group_arn"  { value = azurerm_log_analytics_workspace.this.id }
