variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for dette miljøet."
}

variable "environment"  { type = string }
variable "location"     { type = string }
variable "name_prefix" {
  type    = string
  default = "demo"
}

variable "vnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}
variable "allow_ssh_cidr" {
  type        = string
  default     = null
  description = "Sett /32 for din offentlige IP i dev; null i test/prod."
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "ssh_public_key"   { type = string }
variable "allocate_public_ip" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
