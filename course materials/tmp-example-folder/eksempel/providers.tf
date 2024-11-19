terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.5"  # version number updated
    }
  }
  
  backend "azurerm" {
    # Backend configuration, if needed / used
  }
}

provider "azurerm" {
  features {}
}

