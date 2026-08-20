terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.39.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "" # Add your subscription ID here (found in Azure Portal) - Or use Windows environment variable AZURE_SUBSCRIPTION_ID / MacOS/Linux environment variable AZURE_SUBSCRIPTION_ID
  features {
    
  }
}

resource "azurerm_resource_group" "fd-rg" {
  name     = "rg-demo-we-tim" # Use a unique name for the resource group, prefix or suffix with your initials tim-demo-rg-we / rg-demo-we-tim
  location = "West Europe"
}

resource "azurerm_storage_account" "sa-demo" {
  name                     = "timdsfssmo1qfder"
  resource_group_name      = azurerm_resource_group.fd-rg.name
  location                 = azurerm_resource_group.fd-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}