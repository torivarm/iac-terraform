variable "company" {
  type        = string
  description = "Company name"
  default = "company"
}

variable "project" {
  type        = string
  description = "Project name"
  default = "project"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
  default = "billing_code"
}

variable "kv_rgname" {
  type        = string
  description = "Key Vault Resource Group Name"
  default = "rg-kv"
}

variable "kv_location" {
  type        = string
  description = "location of the Key Vault"
}

variable "kv_base_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "sa_base_name" {
  type        = string
  description = "The name of the storage account"
}

variable "sa_rgname" {
  type        = string
  description = "The name of the resource group"
}

variable "sa_location" {
  type        = string
  description = "The Azure region where resources will be created"
  default = "westeurope"
}

variable "sa_container_name" {
  type        = string
  description = "The name of the storage container"
  default = "sacomtainer"
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