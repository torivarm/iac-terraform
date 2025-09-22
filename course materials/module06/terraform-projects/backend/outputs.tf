output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.sa.name
}

output "state_container_name" {
  description = "Container name for Terraform state"
  value       = azurerm_storage_container.state.name
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.kv.name
}

output "tenant_id" {
  description = "Azure AD tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Subscription ID used"
  value       = coalesce(var.subscription_id, data.azurerm_client_config.current.subscription_id)
}

# Practical: ready-to-paste backend.hcl (sans secrets)
output "backend_hcl_example" {
  description = "A convenience heredoc you can write to backend.hcl"
  value       = <<EOT
resource_group_name  = "${azurerm_resource_group.rg.name}"
storage_account_name = "${azurerm_storage_account.sa.name}"
container_name       = "${azurerm_storage_container.state.name}"
use_azuread_auth     = true
EOT
}
