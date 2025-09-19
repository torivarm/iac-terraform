output "vm_id" {
  description = "ID for VM."
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip" {
  description = "Privat IP."
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip" {
  description = "Offentlig IP (tom dersom slått av)."
  value       = try(azurerm_public_ip.this[0].ip_address, null)
}
