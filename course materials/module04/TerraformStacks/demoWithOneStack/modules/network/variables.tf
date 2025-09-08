variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)."
}

variable "location" {
  type        = string
  description = "Azure-region, f.eks. westeurope."
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for ressurser."
  default     = "demo"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR for virtuelt nett."
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR for subnett."
  default     = "10.10.1.0/24"
}

variable "allow_ssh_cidr" {
  type        = string
  description = "Tillatt kilde-CIDR for SSH (f.eks. egen IP /32). Null for å ikke åpne."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Valgfrie tags."
  default     = {}
}
