output "dev_storage_account" {
  value = azurerm_storage_account.dev.name
}

output "prod_storage_account" {
  value = azurerm_storage_account.prod.name
}

output "resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}
