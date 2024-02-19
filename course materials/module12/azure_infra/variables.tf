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

variable "vnetname" {
    description = "The name of the virtual network"
    type        = string
    default = "vnet-tf-demo-001"
}

variable "subnetname" {
    description = "The name of the subnet"
    type        = string
    default = "subnet-tf-demo-001"
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

variable "sa_name" {
    description = "The name of the storage account"
    type        = string
    default = "sadbtfdemo001"
}

variable "subnet_id" {
    description = "The ID of the subnet"
    type        = string
    default = ""
}

variable "vmssname" {
  description = "The name of the virtual machine scale set"
  type        = string
  default = "vmss-tf-demo-001"
}