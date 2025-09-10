terraform {
  required_version = ">= 1.6"
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  rg_name = "rg-${var.environment}-${var.name_prefix}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "stack" {
  source             = "../../stacks"
  rg_name            = azurerm_resource_group.rg.name
  location           = var.location
  environment        = var.environment
  name_prefix        = var.name_prefix
  vnet_cidr          = var.vnet_cidr
  subnet_cidr        = var.subnet_cidr
  allow_ssh_cidr     = var.allow_ssh_cidr
  vm_size            = var.vm_size
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_key
  allocate_public_ip = var.allocate_public_ip
  tags               = var.tags
}
