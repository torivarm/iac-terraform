output "rg_name" {
  description = "Navn på Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "Region for Resource Group."
  value       = azurerm_resource_group.rg.location
}

output "subnet_id" {
  description = "ID for subnettet."
  value       = azurerm_subnet.subnet.id
}

output "vnet_name" {
  description = "Navn på VNet."
  value       = azurerm_virtual_network.vnet.name
}
