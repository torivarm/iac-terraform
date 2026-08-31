$ErrorActionPreference = "Stop"

# Lag mapper
$envs = "dev","test","prod"
$dirs = @("stacks","modules/resourcegroup") + ($envs | ForEach-Object { "environments/$_" })
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# Modul-filer
@'
resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
}
'@ | Set-Content modules/resourcegroup/main.tf

@'
variable "rg_name" {
  type        = string
  description = "Navnet på resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}
'@ | Set-Content modules/resourcegroup/variables.tf

@'
output "rg_name" {
  value = azurerm_resource_group.this.name
}
'@ | Set-Content modules/resourcegroup/outputs.tf

# Template til environments
$main = @'
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "rg" {
  source   = "../../modules/resourcegroup"
  rg_name  = var.rg_name
  location = var.location
}
'@

$vars = @'
variable "rg_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}
'@

$outputs = @'
output "rg_name" {
  value = module.rg.rg_name
}
'@

foreach ($e in $envs) {
  Set-Content "environments/$e/main.tf" $main
  Set-Content "environments/$e/variables.tf" $vars
  Set-Content "environments/$e/outputs.tf" $outputs
  @"
rg_name = "rg-$e"
location = "westeurope"
"@ | Set-Content "environments/$e/$e.tfvars"
}

# stacks
@'
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
'@ | Set-Content stacks/main.tf

New-Item -ItemType File stacks/variables.tf -Force | Out-Null
New-Item -ItemType File stacks/outputs.tf   -Force | Out-Null

Write-Host "✅ Struktur og filer opprettet."
