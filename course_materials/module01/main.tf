terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "a3adf20e-4966-4afb-b717-4de1baae6db1" # Add your subscription ID here (found in Azure Portal) - Or use Windows environment variable AZURE_SUBSCRIPTION_ID / MacOS/Linux environment variable AZURE_SUBSCRIPTION_ID
}


resource "azurerm_resource_group" "rg-sa" {
  name     = "example-resources123"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "timdemo123iac"
  resource_group_name      = azurerm_resource_group.rg-sa.name
  location                 = azurerm_resource_group.rg-sa.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}