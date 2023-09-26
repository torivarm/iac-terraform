variable "sa_base_name" {
    type = string
    description = "The name of the storage account"
}

variable "sa_rgname" {
    type = string
    description = "The name of the resource group"
}

variable "sa_location" {
    type = string
    description = "The Azure region where resources will be created"
}

variable "sa_container_name" {
    type = string
    description = "The name of the storage container"
}