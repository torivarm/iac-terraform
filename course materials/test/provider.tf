terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-yb"
    storage_account_name = "tfstatestorageyb"
    container_name       = "tfstatecontaineryb"
    key                  = "test2.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}