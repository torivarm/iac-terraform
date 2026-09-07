output "resource_group_name" {
  description = "Navnet på ressursgruppen som ble opprettet"
  value       = azurerm_resource_group.rg.name
}

output "name_prefix" {
  description = "Navneprefikset alle ressursene dine deler"
  value       = local.name_prefix
}