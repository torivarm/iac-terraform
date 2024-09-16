terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }

}

provider "azurerm" {
  subscription_id = "" # The subscription ID to use
  features {
  }
}

