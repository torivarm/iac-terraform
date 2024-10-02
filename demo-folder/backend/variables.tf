# variables for backend configuration

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the storage account will be created."
  default     = "rg-demo-backend-tim"
}

variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to create."
  default     = "sademobackendtim"

}