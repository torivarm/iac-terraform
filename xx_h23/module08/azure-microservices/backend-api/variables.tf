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

variable "apim_name" {
  type        = string
  default     = "apim"
  description = "value of the api management name"
  
}