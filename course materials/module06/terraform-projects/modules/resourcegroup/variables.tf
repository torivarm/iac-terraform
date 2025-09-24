variable "rg_name" {
  type        = string
  description = "Navnet på resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}
