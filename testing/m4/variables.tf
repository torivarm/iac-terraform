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
  default     = "norwayeast" # eller overstyr i terraform.tfvars
}

variable "vnet_name" {
  description = "Navnet på det virtuelle nettverket"
  type        = string
  default     = "example-network"
}