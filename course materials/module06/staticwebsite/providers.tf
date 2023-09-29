terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-backend-tfstate"
    storage_account_name = "sabetfs3a9npz46p2"
    container_name       = "tfstate"
    key                  = "web.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}