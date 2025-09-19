variable "environment" {
  description = "Miljønavn."
  type        = string
}
variable "location" {
  description = "Azure location."
  type        = string
}
variable "name_prefix" {
  description = "Prefiks for navngiving."
  type        = string
}
variable "subscription_id" {
  description = "Azure Subscription ID."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
}
variable "subnet_prefixes" {
  description = "CIDR for subnets."
  type        = list(string)
}

variable "vm_size" {
  description = "VM-størrelse."
  type        = string
}
variable "ssh_public_key" {
  description = "SSH public key-innhold."
  type        = string
}
variable "enable_public_ip" {
  description = "Opprett Public IP?"
  type        = bool
}
