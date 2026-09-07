terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id hentes fra ARM_SUBSCRIPTION_ID
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.location

  # Tagger gjør det enkelt å finne igjen egne ressurser i et delt abonnement
  tags = local.common_tags
}

module "network" {
  source                = "./modules/network"
  name_prefix           = local.name_prefix
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  address_space         = ["10.0.0.0/16"]
  subnet_address_prefix = ["10.0.1.0/24"]
  tags                  = local.common_tags
}


