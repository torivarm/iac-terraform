variable "location" {
  type        = string
  description = "Location of the resource"
  default     = "westeurope"
}
variable "rg_name" {
  type        = string
  description = "Name of the resource group"
  default     = "web-demo-rg"
}

variable "sa_name" {
  type        = string
  description = "Name of the storage account"
  default     = "webdemosa"
}

variable "source_content" {
  type        = string
  description = "Source content for the index.html file"
  default     = "<h1>Web page created with Terraform - NEW</h1>"
}

variable "index_document" {
  type        = string
  description = "Name of the index document"
  default     = "index.html"
}