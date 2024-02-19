terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
    features {
    }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}