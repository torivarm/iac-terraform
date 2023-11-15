variable "vnet_rg_name" {
    type = string
    description = "Resource group name"
    default = "rg-vnet"
}

variable "vnet_rg_location" {
    type = string
    description = "Resource group location"
    default = "westeurope"
}

variable "vnet_name" {
    type = string
    description = "Virtual network name"
    default = "vnet"
}

variable "nsg_name" {
    type = string
    description = "Network security group name"
    default = "nsg"
}

variable "subnet_name" {
    type = string
    description = "Subnet name"
    default = "subnet"
}