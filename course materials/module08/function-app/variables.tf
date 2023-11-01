################################################
######          General variables         ######
################################################
variable "base_name" {
  type        = string
  default     = "demo"
  description = "value of the base name"
}

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

################################################
###### Variable for the storageaccount.tf ######
################################################

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


################################################
######      Azure Linux Function App      ######
################################################
variable "funcapp_name" {
  type        = string
  default     = "funcapp"
  description = "value of the function app name"
}


################################################
######        Application Insights        ######
################################################
variable "ai_name" {
  type        = string
  default     = "ai"
  description = "value of the application insights name"

}


################################################
######          App Service Plan          ######
################################################
variable "sp_name" {
  type        = string
  default     = "sp"
  description = "value of the app service plan name"
}