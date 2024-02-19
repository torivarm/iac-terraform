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

module "network" {
  source = "./modules/network"
  rgname = var.rgname
  location = var.location
  vnetname = var.vnetname
  nsgname = var.subnetname
}

module "database" {
  source = "./modules/database"
  rgname = var.rgname
  location = var.location
  sa_name = var.sa_name
  mssqldb_name = var.mssqldb_name
  mssql_name = var.mssql_name
}

module "vmss" {
  source = "./modules/vmss"
  rgname = var.rgname
  location = var.location
  vmssname = var.vmssname
  subnet_id = module.network.subnet_id
}