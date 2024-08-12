variable "vm_rg_name" {
    type = string
    description = "Resource group name"
}

variable "vm_rg_location" {
    type = string
    description = "Resource group location"
}

variable "vm_nic_name" {
    type = string
    description = "Network interface name"
}

variable "vm_subnet_id" {
    type = string
    description = "Subnet ID"
}

variable "vm_name" {
    type = string
    description = "Virtual machine name"
}

variable "pip_name" {
    type = string
    description = "Public IP name"
}

variable "vm_username" {
    type = string
    description = "Virtual machine username"
    sensitive = true
}

variable "vm_password" {
    type = string
    description = "Virtual machine password"
    sensitive = true
}
