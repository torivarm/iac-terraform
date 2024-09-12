terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "5513747a-818d-4f48-83b0-da2b2fd4cb97"
  features {

  }
}


# Create the resource group in the root module
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

