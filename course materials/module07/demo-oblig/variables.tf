variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
}

variable "kv_rgname" {
  type        = string
  description = "Key Vault Resource Group Name"
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
}

variable "sa_container_name" {
  type        = string
  description = "The name of the storage container"
}

variable "vnet_rg_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_rg_location" {
  type        = string
  description = "Resource group location"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name"
}

variable "nsg_name" {
  type        = string
  description = "Network security group name"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "vm_rg_name" {
  type        = string
  description = "Resource group name"
}

variable "vm_rg_location" {
  type        = string
  description = "Resource group location"
}

variable "vm_nic_name" {
  type        = string
  description = "Network interface name"
}

variable "vm_name" {
  type        = string
  description = "Virtual machine name"
}

variable "pip_name" {
  type        = string
  description = "public IP name"
}