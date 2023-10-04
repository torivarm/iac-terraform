variable "kv_rgname" {
    type = string
    description = "Key Vault Resource Group Name"
}

variable "kv_location" {
    type = string
    description = "location of the Key Vault"
}

variable "kv_base_name" {
    type = string
    description = "Name of the Key Vault"
}

variable "sa_access_key" {
    type = string
    description = "Storage account access key"
}

variable "sa_name" {
    type = string
    description = "storage account name"
}