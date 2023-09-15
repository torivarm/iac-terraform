terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-sa-01"
    storage_account_name = "sauajuaztk2t"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    access_key           = "dxErr36GqZZR9vy7SbK6wvL0ppI4MhDUCaluGKaUzq/OqrRpPL9sRppMFr8EuqHk0/q6119xBoPQ+ASt8+IBrg=="
  }
}

provider "azurerm" {
  features {
  }
}

module "keyvault" {
  source        = "./keyvault"
  kv_rgname     = var.kv_rgname
  kv_location   = var.kv_location
  kv_base_name  = var.kv_base_name
  sa_access_key = module.StorageAccount.primary_access_key_output
  sa_name       = "sauajuaztk2t"
}

module "StorageAccount" {
  source            = "./storageaccount"
  sa_rgname         = var.sa_rgname
  sa_location       = var.sa_location
  sa_base_name      = var.sa_base_name
  sa_container_name = var.sa_container_name
}

module "Network" {
  source           = "./network"
  vnet_rg_name     = var.vnet_rg_name
  vnet_rg_location = var.vnet_rg_location
  vnet_name        = var.vnet_name
  nsg_name         = var.nsg_name
  subnet_name      = var.subnet_name
}

module "VirtualMachine" {
  source         = "./virtualmachine"
  vm_name        = var.vm_name
  vm_rg_name     = var.vm_rg_name
  vm_rg_location = var.vm_rg_location
  vm_nic_name    = var.vm_nic_name
  vm_subnet_id   = module.Network.subnet_id_output
  pip_name       = var.pip_name
}
