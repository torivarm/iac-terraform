variable "name_prefix" {
  description = "Kort prefiks for ressursnavn."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG (må eksistere)."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID der NIC skal kobles."
  type        = string
}

variable "vm_size" {
  description = "Størrelse på VM."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Adminbruker på VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key-innhold."
  type        = string
}

variable "enable_public_ip" {
  description = "Opprett Public IP?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Standard tags."
  type        = map(string)
  default     = {}
}
