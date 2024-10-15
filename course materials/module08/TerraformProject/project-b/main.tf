terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
  backend "azurerm" {
    key = "project_b.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "5513747a-818d-4f48-83b0-da2b2fd4cb97"
  features {

  }
}


# project_b/main.tf
resource "azurerm_resource_group" "rg_b" {
  name     = var.resource_group_name
  location = var.location
}

