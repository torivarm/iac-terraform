terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.69.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "rg-first" {
  name = "rg-demo-we"
  location = "west europe"
}

resource "azurerm_storage_account" "sa-demo" {
  name = "tim12345tim"
  resource_group_name = azurerm_resource_group.rg-first.name
  location = azurerm_resource_group.rg-first.location
  account_tier = "Standard"
  account_replication_type = "GRS"

  tags = {
  }
}