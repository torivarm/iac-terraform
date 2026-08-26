variable "rg_name" {
  type        = string
  description = "Resource Group for VM."
}

variable "location" {
  type        = string
  description = "Azure-region for VM."
}

variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)."
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for VM-relaterte ressurser."
  default     = "demo"
}

variable "subnet_id" {
  type        = string
  description = "Subnett-ID som NIC skal tilknyttes."
}

variable "vm_size" {
  type        = string
  description = "Maskinstørrelse (SKU)."
  default     = "Standard_B1s"
}

variable "admin_username" {
  type        = string
  description = "Administratorbruker for VM."
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "Innholdet i offentlig SSH-nøkkel (f.eks. ~/.ssh/id_ed25519.pub)."
}

variable "allocate_public_ip" {
  type        = bool
  description = "Opprett offentlig IP for enkel demo-tilgang."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Valgfrie tags."
  default     = {}
}
