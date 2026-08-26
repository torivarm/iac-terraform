terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


#######################################
############## Variables ##############
#######################################

variable "subscription_id" {
  type        = string
  description = "The Subscription ID to deploy resources to"
  default     = "xxxx-xxxx-xxxx-xxxx" # Insert your Azure subscription ID between the quotes
}

variable "nameprefix" {
  type        = string
  description = "The prefix to use for all resources"
  default     = "tim"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources to"
  default     = "westeurope"
}

variable "project" {
  type        = string
  description = "The project name"
  default     = "localsdemo"
}

variable "environment" {
  type        = string
  description = "The environment name"
  default     = "test"
}

#######################################
############### Locals ################
#######################################

locals {

  resource_group_name = "${var.nameprefix}-${var.project}-${var.environment}-rg"

  tags = {
    owner       = "tor.i.melling@mycompany.com"
    costcenter  = "123SD45"
    project     = var.project
    environment = var.environment
  }

}

#######################################
############ Resources ################
#######################################

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location

  tags = local.tags
}

resource "azurerm_storage_account" "main" {
  name                     = "st${var.nameprefix}${var.project}${var.environment}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags

}