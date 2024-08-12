resource "random_string" "random_string" {
    length = 10
    special = false
    upper = false
}

resource "azurerm_resource_group" "sa_rg" {
  name     = var.sa_rgname
  location = var.sa_location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.sa_base_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.sa_rg.name
  location                 = azurerm_resource_group.sa_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.sa_container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}