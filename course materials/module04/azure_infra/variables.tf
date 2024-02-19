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