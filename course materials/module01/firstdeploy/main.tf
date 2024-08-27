terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "68efcd46-9053-4a1a-b840-d571b4d1fe84"
  features {
    
  }
}

resource "azurerm_resource_group" "fd-rg" {
  name     = "rg-demo-we" # Use a unique name for the resource group, prefix or suffix with your initials tim-demo-rg-we / rg-demo-we-tim
  location = "West Europe"
}

resource "azurerm_storage_account" "sa-demo" {
  name                     = "timdemo1q34fsder"
  resource_group_name      = azurerm_resource_group.fd-rg.name
  location                 = azurerm_resource_group.fd-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}