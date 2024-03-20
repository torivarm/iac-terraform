
variable "location" {
  type        = string
  description = "Deployment location"
  default     = "West Europe"
}

variable "rgname" {
  type        = string
  description = "Resource Groupe Name"
  default     = "rg-demo-terraform"
}

variable "saname" {
  type        = string
  description = "Storage Account name"
}

variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
}

variable "az_regions" {
  type        = list(string)
  description = "Azure regions for resources"
  default     = ["northeurope", "westeurope"]
}

variable "vmsize" {
  type = map(string)
  default = {
    "small"  = "Standard_B1s"
    "medium" = "Standard_B2s"
    "large"  = "Standard_B4ms"
  }
}

variable "storage_account_names" {
  type        = list(string)
  description = "values for storage account names"
  default = [ "storage123", "storage456"]
}

