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