variable "sa_name" {
    description = "The name of the storage account"
    type        = string
    default = "sadbtfdemo001"
}

variable "rgname" {
    description = "The name of the resource group"
    type        = string
    default = "rg-tf-demo"
}

variable "location" {
    description = "The location/region of the resource group"
    type        = string
    default = "westeurope" 
}

variable "mssql_name" {
    description = "The name of the SQL Server"
    type        = string
    default = "mssql-tf-demo-001"
}

variable "mssqldb_name" {
    description = "The name of the SQL Database"
    type        = string
    default = "mssqldb-tf-demo-001"
}
