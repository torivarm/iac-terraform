output "subnet_id" {
    description = "ID til subnettet. Dette er verdien en NIC, en private endpoint eller en NSG-assosiasjon trenger."
    value = azurerm_subnet.subnet.id
}

output "subnet_name" {
    description = "Navnet på subnettet."
    value = azurerm_subnet.subnet.name
}

output "vnet_id" {
  description = "ID til det virtuelle nettverket. Brukes blant annet ved VNet-peering."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Navnet på det virtuelle nettverket."
  value       = azurerm_virtual_network.vnet.name
}