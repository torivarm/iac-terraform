terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_string" "random_string" {
    length = 6
    special = false
    upper = false
}

resource "azurerm_storage_account" "example" {
  name                     = "${lower(var.base_name)}${random_string.random_string.result}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}