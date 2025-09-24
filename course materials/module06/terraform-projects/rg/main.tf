terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "fd-rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_storage_account" "sa_demo" {
    name                     = "sademonametim12357"
    resource_group_name      = azurerm_resource_group.fd-rg.name
    location                 = azurerm_resource_group.fd-rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}


### Input variables ###

variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure location for the Resource Group"
  type        = string
}