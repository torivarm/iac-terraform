terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "683886f5-1985-4666-a868-6e00a44de5bd"
  features {

  }
}
