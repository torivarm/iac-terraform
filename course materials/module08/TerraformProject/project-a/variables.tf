# Variables for the main configuration
variable "resource_group_name" {
  type        = string
  default     = "rg-demo-project-a"
  description = "The name of the resource group"
}
variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location of the storage account"
}



# Variables for the storage account
variable "storage_account_name" {
  type        = string
  default     = "sademotim12345"
  description = "The name of the storage account"
}


