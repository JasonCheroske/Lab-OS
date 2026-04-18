output "bucket_name"   { value = azurerm_storage_container.this.name }
output "bucket_arn"    { value = azurerm_storage_account.this.id }
output "bucket_domain" { value = azurerm_storage_account.this.primary_blob_endpoint }
