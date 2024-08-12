variable "vnet_rg_name" {
    type = string
    description = "Resource group name"
}

variable "vnet_rg_location" {
    type = string
    description = "Resource group location"
}

variable "vnet_name" {
    type = string
    description = "Virtual network name"
}

variable "nsg_name" {
    type = string
    description = "Network security group name"
}

variable "subnet_name" {
    type = string
    description = "Subnet name"
}