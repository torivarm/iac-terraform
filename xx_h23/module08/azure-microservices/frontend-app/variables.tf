variable "rg_name" {
  type        = string
  default     = "rg"
  description = "Name of the resource group to create"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure region to deploy resources"
}

variable "funcapp_name" {
  type        = string
  default     = "funcapp"
  description = "value of the function app name"
}

variable "sp_name" {
  type        = string
  default     = "sp"
  description = "value of the app service plan name"
}

variable "sa_name" {
  type        = string
  default     = "sa"
  description = "value of the storage account name"
}

variable "sc_name" {
  type        = string
  default     = "sc"
  description = "value of the storage container name"
}
