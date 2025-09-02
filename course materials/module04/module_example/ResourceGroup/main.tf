resource "azurerm_resource_group" "example" {
  name     = "rg-${var.base_name}"
  location = var.location
}

