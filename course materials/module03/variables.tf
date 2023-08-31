
variable "location" {
  type        = string
  description = "Deployment location"
  default     = "West Europe"
}

variable "rgname" {
  type        = string
  description = "Resource Groupe Name"
  default     = "rg-demo-terraform"
}

variable "saname" {
  type        = string
  description = "Storage Account name"
}