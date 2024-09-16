variable "rg_backend_name" {
  type        = string
  description = "Name of the resource group for the backend"
  default     = "rg-terraform-backend-tim"
}

variable "rg_backend_location" {
  type        = string
  description = "Location of the resource group for the backend"
  default     = "westeurope"
}

variable "sa_backend_name" {
  type        = string
  description = "Name of the storage account for the backend"
  default     = "sabetfstim"
}

variable "sc_backend_name" {
  type        = string
  description = "Name of the storage container for the backend"
  default     = "tfstate"
}

variable "sa_backend_accesskey_name" {
  type        = string
  description = "Name of the storage account access key for the backend"
  default     = "tfstateaccesskey"
}

variable "kv_backend_name" {
  type        = string
  description = "Name of the key vault for the backend"
  default     = "kv-tim-backend"
}