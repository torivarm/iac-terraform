# Variables for main.tf root module
variable "resource_group_name" {
  description = "The name of the resource group in Azure"
  type        = string
  default     = "rg-demo-tf"
}

variable "location" {
  description = "The location/region where the resources will be created"
  type        = string
  default     = "westeurope"
}

