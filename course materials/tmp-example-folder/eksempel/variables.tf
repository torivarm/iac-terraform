variable "environment" {
  description = "env (dev, test, prod)"
  type        = string
}

variable "location" {
  description = "Azure region resources will be deployed to"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name on resource group"
  type        = string
}

variable "address_space" {
  description = "VNET address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "Subnet address prefixes"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}