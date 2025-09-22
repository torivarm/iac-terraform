variable "environment" {
  description = "Miljønavn (dev/test/prod)."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Prefiks for navngiving (korte, konsise)."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG som eies av environment."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR for subnets."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "vm_size" {
  description = "VM-størrelse."
  type        = string
  default     = "Standard_B2s"
}

variable "ssh_public_key" {
  description = "SSH public key-innhold for VM-innlogging."
  type        = string
}

variable "enable_public_ip" {
  description = "Opprett Public IP for VM?"
  type        = bool
  default     = true
}
