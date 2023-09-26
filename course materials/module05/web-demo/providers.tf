terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-backend-tfstate-dev"
    storage_account_name = "sabetfss61r3a4sy5"
    container_name       = "tfstate"
    key                  = "web-demo.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}