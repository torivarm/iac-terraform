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

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}
variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}

variable "mssqlname" {
  type        = string
  description = "The name of the SQL Server."
  default     = "sqlserver"  
}

variable "create_resource_group" {
  description = "Flag to create new resource group"
  type        = bool
}

variable "existing_resource_group_name" {
  type = string
  description = "value of the existing resource group name"
}