output "vm_id" {
  description = "Ressurs-ID for VM."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "private_ip" {
  description = "Privat IP for VM."
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "public_ip" {
  description = "Offentlig IP (hvis opprettet)."
  value       = try(azurerm_public_ip.pip[0].ip_address, null)
}
