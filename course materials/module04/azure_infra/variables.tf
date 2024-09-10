variable "rgname" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-tf-demo"
}

variable "location" {
  description = "The location/region of the resource group"
  type        = string
  default     = "westeurope"
}

# variables for the network module
variable "nsgname" {
  description = "The name of the network security group"
  type        = string
  default     = "nsg-tf-demo-001"
}

variable "vnetname" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-tf-demo-001"
}

variable "subnetname" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet-tf-demo-001"
}

# Variables for the DB module
variable "saname" {
  description = "The name of the storage account"
  type        = string
  default     = "satfdemo001"
}

variable "mssqlname" {
  description = "The name of the SQL database"
  type        = string
  default     = "mssqldb001"
}

variable "mssqldbname" {
  description = "The name of the SQL database"
  type        = string
  default     = "mssqldb001"
}

# variables for the VMSS module
variable "vmssname" {
  description = "The name of the virtual machine scale set"
  type        = string
  default     = "vmss-tf-demo-001"
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
  default     = ""
}