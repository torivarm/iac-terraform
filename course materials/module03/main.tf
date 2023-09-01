terraform {
  required_providers {
    azurerm = {
<<<<<<< HEAD
      source  = "hashicorp/azurerm"
      version = "3.69.0"
=======
        source = "hashicorp/azurerm"
        version = "3.69.0"
>>>>>>> 6a4a078e051c3cf12ba09c0a9c1810039dbe3c01
    }
  }
}

provider "azurerm" {
  features {

  }
<<<<<<< HEAD
}

locals {
  name = "LearnIT"
  tags = {
    environment = "Production"
    owner       = "DevOps Team"
  }
}


resource "azurerm_resource_group" "rgwe" {
  name     = var.rgname
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "sa-demo" {
  name                     = var.saname
  resource_group_name      = azurerm_resource_group.rgwe.name
  location                 = azurerm_resource_group.rgwe.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
=======
>>>>>>> 6a4a078e051c3cf12ba09c0a9c1810039dbe3c01
}