output "vnet_id" {
  description = "ID for VNet."
  value       = azurerm_virtual_network.this.id
}

output "subnet_id" {
  description = "ID for første subnet."
  value       = azurerm_subnet.this.id
}
