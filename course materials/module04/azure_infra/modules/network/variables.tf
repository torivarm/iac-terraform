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

variable "subnetname" {
  description = "The name of the subnet"
  type        = string
  default     = "subnet-tf-demo-001"
}