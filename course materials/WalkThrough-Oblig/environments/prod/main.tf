terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }

  backend "azurerm" {
    # Sett disse via -backend-config ved terraform init (anbefalt):
    # resource_group_name  =
    # storage_account_name =
    # container_name       =
    # key                  =
  }
}

provider "azurerm" {
  features {}
}

# Environment eier Resource Group
locals {
  env_prefix = "${var.name_prefix}-${var.environment}"
  env_tags = {
    environment = var.environment
    managed_by  = "terraform"
    owner       = "platform-team"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.env_prefix}-rg"
  location = var.location
  tags     = local.env_tags
}

module "stack" {
  source              = "../../stacks"
  environment         = var.environment
  location            = var.location
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg.name

  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  enable_public_ip    = var.enable_public_ip
}
