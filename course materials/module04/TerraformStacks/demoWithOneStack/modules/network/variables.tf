variable "rg_name" {
  type        = string
  description = "Navn på eksisterende Resource Group der nettverksressurser skal opprettes."
}

variable "location" {
  type        = string
  description = "Azure-region (må samsvare med RG)."
}

variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)."
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for nettverksressurser."
  default     = "demo"
}

variable "vnet_cidr"   { 
  type = string
  default = "10.10.0.0/16" 
  }
variable "subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "allow_ssh_cidr" {
  type        = string
  default     = null
  description = "Tillatt kilde-CIDR for SSH; null for å ikke åpne."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Ekstra tags."
}
