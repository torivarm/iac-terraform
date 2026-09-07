output "resource_group_name" {
  description = "Navnet på ressursgruppen som ble opprettet"
  value       = azurerm_resource_group.rg.name
}

output "name_prefix" {
  description = "Navneprefikset alle ressursene dine deler"
  value       = local.name_prefix
}

output "vnet_name" {
  description = "Navnet på det virtuelle nettverket, også hentet ut av modulen."
  value       = module.network.vnet_name
}

output "subnet_id" {
  description = "ID til subnettet, hentet ut av modulen."
  value       = module.network.subnet_id
}