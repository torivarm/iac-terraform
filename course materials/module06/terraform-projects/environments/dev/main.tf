terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "rg" {
  source   = "../../modules/resourcegroup"
  rg_name  = var.rg_name
  location = var.location
}
