terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Felles naming & tags – sentralisert i stacken
locals {
  # Konsis navnestandard: <prefix>-<env>-<res>
  name_prefix = "${var.name_prefix}-${var.environment}"

  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
    iac_stack   = "base"
  }
}

# Ressursgruppe for hele stacken
resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source              = "../modules/network"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = local.common_tags
}

module "compute_vm" {
  source              = "../modules/compute-vm"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  enable_public_ip    = var.enable_public_ip
  tags                = local.common_tags
}
