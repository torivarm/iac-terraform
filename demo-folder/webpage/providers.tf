terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-demo-backend-tim" # The name of the resource group to create the storage account in
    storage_account_name = "sademobackendtim"     # The name of the storage account to create
    container_name       = "tfstate"                  # The name of the blob container to create
    key                  = "web.terraform.tfstate"    # The name of the blob to store the state file in
  }
}

provider "azurerm" {
  subscription_id = "5513747a-818d-4f48-83b0-da2b2fd4cb97"
  features {
  }
}