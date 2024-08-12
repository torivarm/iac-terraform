variable "location" {
  type        = string
  description = "Location of the resource"
  default     = "westeurope"
}
variable "rg_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-web"
}

variable "sa_name" {
  type        = string
  description = "Name of the storage account"
  default     = "saweb"
}

variable "source_content" {
  type        = string
  description = "Source content for the index.html file"
  default     = "<h1>Made with Terraform - CI/CD - update del 2</h1>"
}

variable "index_document" {
  type        = string
  description = "Name of the index document"
  default     = "index.html"
}