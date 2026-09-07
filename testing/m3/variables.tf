variable "student_id" {
  description = "Din unike student-ID. Brukes som prefiks i alle ressursnavn."
  type        = string
  default     = "tim84"

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.student_id))
    error_message = "student_id må være 3-8 tegn og kun inneholde små bokstaver og tall."
  }
}

variable "project" {
  description = "Kort prosjektnavn brukt i ressursnavn"
  type        = string
  default     = "iac"

  validation {
    condition     = length(var.project) <= 10
    error_message = "Prosjektnavnet kan ikke være lengre enn 10 tegn."
  }
}

variable "location" {
  description = "Azure-region for ressursene"
  type        = string
  default     = "<din tillatte region>" # eller overstyr i terraform.tfvars
}

variable "ssh_public_key" {
  description = "Offentlig SSH-nøkkel for admin-brukeren på VM-en"
  type        = string
  # Ikke sensitive: en offentlig nøkkel er ikke en hemmelighet
}

variable "nsg_rules" {
  description = "Innkommende regler NSG-en skal generere"
  type = list(object({
    name     = string
    priority = number
    port     = string
  }))
  default = [
    { name = "allow_ssh", priority = 100, port = "22" },
  ]
}

variable "vnet_name" {
  description = "Navnet på det virtuelle nettverket"
  type        = string
  default     = "example-network"
}

variable "create_nsg" {
  description = "Om NSG skal opprettes"
  type        = bool
  default     = true
}

variable "subnets" {
  type = map(string)
  default = {
    web = "10.0.1.0/24"
    db  = "10.0.2.0/24"
  }
}