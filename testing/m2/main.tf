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
  name     = local.resource_group_name
  location = var.location

  # Tagger gjør det enkelt å finne igjen egne ressurser i et delt abonnement
  tags = {
    student = var.student_id
    course  = "iac"
  }
}