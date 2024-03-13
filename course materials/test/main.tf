# Create Resource Group
resource "azurerm_resource_group" "rg_web" {
  name     = "rg-test"
  location = "westeurope"
}