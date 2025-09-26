variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "app_name" {
  description = "Web App name (globally unique)"
  type        = string
}

variable "sku" {
  description = "App Service Plan SKU (e.g., B1, P1v3)"
  type        = string
  default     = "B1"
}

variable "app_settings" {
  description = "App settings for the Web App"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
