output "storage_account_name_output" {
  value       = azurerm_storage_account.sa.name
  description = "Name of the Azure Storage Account"
}

output "blob_container_name_output" {
  value       = azurerm_storage_container.storage_container.name
  description = "Name of the Blob container"
}

output "primary_access_key_output" {
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
  description = "Azure Storage Account - Primary access key"
}