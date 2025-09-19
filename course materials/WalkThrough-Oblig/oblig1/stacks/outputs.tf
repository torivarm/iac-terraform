output "resource_group_name" {
  description = "Navn på RG."
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID til VNet."
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "ID til Subnet."
  value       = module.network.subnet_id
}

output "vm_id" {
  description = "ID for VM."
  value       = module.compute_vm.vm_id
}

output "vm_private_ip" {
  description = "Privat IP for VM."
  value       = module.compute_vm.private_ip
}

output "vm_public_ip" {
  description = "Offentlig IP for VM (om aktivert)."
  value       = module.compute_vm.public_ip
}
