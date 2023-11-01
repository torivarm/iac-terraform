resource "azurerm_resource_group" "rg-app" {
  name     = "${var.rg_name}-${random_string.random_string.result}"
  location = var.location
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
}

# App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.sp_name}${random_string.random_string.result}"
  location            = azurerm_resource_group.rg-app.location
  resource_group_name = azurerm_resource_group.rg-app.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Function App
resource "azurerm_linux_function_app" "funcapp" {
  name                       = "${var.funcapp_name}-${random_string.random_string.result}"
  resource_group_name        = azurerm_resource_group.rg-app.name
  location                   = azurerm_resource_group.rg-app.location
  service_plan_id            = azurerm_service_plan.service_plan.id

  site_config {
  }

}