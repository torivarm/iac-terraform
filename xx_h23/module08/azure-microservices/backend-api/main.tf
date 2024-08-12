resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${random_string.random_string.result}"
  location = var.location
}
resource "azurerm_api_management" "api_mgmt" {
  name                = "${var.apim_name}-${random_string.random_string.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_backend" "example" {
  name                = "example-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api_mgmt.name
  protocol            = "http"
  url                 = "https://backend"
}
