output "resource_group_name" {
  value       = module.stack.resource_group_name
  description = "Navn på RG i dette miljøet."
}

output "vm_private_ip" {
  value       = module.stack.vm_private_ip
  description = "Privat IP for VM."
}

output "vm_public_ip" {
  value       = module.stack.vm_public_ip
  description = "Offentlig IP for VM (om aktivert)."
}
