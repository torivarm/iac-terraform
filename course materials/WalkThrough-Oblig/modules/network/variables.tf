variable "name_prefix" {
  description = "Kort prefiks for ressursnavn (f.eks. 'demo')."
  type        = string
}

variable "location" {
  description = "Azure location (f.eks. 'westeurope')."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG der nettverk skal ligge."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR for subnets i VNet. Første brukes til VM."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "tags" {
  description = "Standard tags å sette på ressurser."
  type        = map(string)
  default     = {}
}
