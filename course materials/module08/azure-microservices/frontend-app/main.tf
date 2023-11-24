resource "azurerm_resource_group" "rg-app" {
  name     = var.rg_name
  location = var.location
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
}

# App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = var.sp_name
  location            = azurerm_resource_group.rg-app.location
  resource_group_name = azurerm_resource_group.rg-app.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Function App
resource "azurerm_linux_function_app" "funcapp" {
  name                       = var.funcapp_name
  resource_group_name        = azurerm_resource_group.rg-app.name
  location                   = azurerm_resource_group.rg-app.location
  storage_account_name       = azurerm_storage_account.sa-funcapp.name
  storage_account_access_key = azurerm_storage_account.sa-funcapp.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id

  site_config {
  }

}

# Storage account for Function App
resource "azurerm_storage_account" "sa-funcapp" {
  name                     = "${var.sa_name}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.rg-app.name
  location                 = azurerm_resource_group.rg-app.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-funcapp" {
  name                  = "${var.sc_name}${random_string.random_string.result}"
  storage_account_name  = azurerm_storage_account.sa-funcapp.name
  container_access_type = "private"
}