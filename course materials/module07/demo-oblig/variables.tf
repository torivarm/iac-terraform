variable "company" {
  type        = string
  description = "Company name"
  default = "LearnTF"
}

variable "project" {
  type        = string
  description = "Project name"
  default = "Project TF"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
  default = "TF12345"
}

variable "kv_rgname" {
  type        = string
  description = "Key Vault Resource Group Name"
  default = "rg-kv"
}

variable "kv_location" {
  type        = string
  description = "location of the Key Vault"
  default = "westeurope"
}

variable "kv_base_name" {
  type        = string
  description = "Name of the Key Vault"
  default = "kvbn"
}

variable "sa_base_name" {
  type        = string
  description = "The name of the storage account"
  default = "sabn"
}

variable "sa_rgname" {
  type        = string
  description = "The name of the resource group"
  default = "rg-sa"
}

variable "sa_location" {
  type        = string
  description = "The Azure region where resources will be created"
  default = "westeurope"
}

variable "sa_container_name" {
  type        = string
  description = "The name of the storage container"
  default = "sacn"
}

variable "vnet_rg_name" {
  type        = string
  description = "Resource group name"
  default = "rg-vnet"
}

variable "vnet_rg_location" {
  type        = string
  description = "Resource group location"
  default = "westeurope"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name"
  default = "vnet"
}

variable "nsg_name" {
  type        = string
  description = "Network security group name"
  default = "nsg"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
  default = "subnet"
}

variable "vm_rg_name" {
  type        = string
  description = "Resource group name"
  default = "rg-vm"
}

variable "vm_rg_location" {
  type        = string
  description = "Resource group location"
  default = "westeurope"
}

variable "vm_nic_name" {
  type        = string
  description = "Network interface name"
  default = "nic"
}

variable "vm_name" {
  type        = string
  description = "Virtual machine name"
  default = "vm"
}

variable "pip_name" {
  type        = string
  description = "public IP name"
  default = "pip"
}

variable "vm_username" {
  type        = string
  description = "Virtual machine username"
  sensitive = true
  default = "azureuser"
}

variable "vm_password" {
  type        = string
  description = "Virtual machine password"
  sensitive = true
  default = "dsfSD_!EfdX12gfZ"
}