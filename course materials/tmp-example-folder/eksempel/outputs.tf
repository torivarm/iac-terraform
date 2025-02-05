output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}