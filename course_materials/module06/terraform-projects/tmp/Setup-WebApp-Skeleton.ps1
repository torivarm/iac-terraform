$ErrorActionPreference = "Stop"

$root = "terraform-projects"
$envs = @("dev","test","prod")

# Mapper
New-Item -ItemType Directory -Force -Path "$root/shared" | Out-Null
$envs | ForEach-Object { New-Item -ItemType Directory -Force -Path "$root/environments/$_" | Out-Null }

# shared/backend.hcl
@'
# Fyll inn verdier som peker til eksisterende state-konto/container
resource_group_name  = "rg-tfstate-REPLACE_ME"
storage_account_name = "sttfstateREPLACE"
container_name       = "tfstate"
use_azuread_auth     = true
'@ | Set-Content "$root/shared/backend.hcl" -Encoding UTF8

# main.tf (korrekt provider-format)
$mainTf = @'
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  tags                = var.tags

  site_config {
    ftps_state = "Disabled"

    application_stack {
      node_version = "18-lts"
      # python_version = "3.11"
      # dotnet_version = "8.0"
    }
  }

  app_settings = var.app_settings
}
'@

# variables.tf (hver variabel i flermlinjeformat)
$varsTf = @'
variable "rg_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "app_name" {
  description = "Web App name (globally unique)"
  type        = string
}

variable "sku" {
  description = "App Service Plan SKU (e.g., B1, P1v3)"
  type        = string
  default     = "B1"
}

variable "app_settings" {
  description = "App settings for the Web App"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
'@

# outputs.tf
$outputsTf = @'
output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "plan_id" {
  value = azurerm_service_plan.plan.id
}

output "webapp_id" {
  value = azurerm_linux_web_app.app.id
}

output "webapp_url" {
  value = azurerm_linux_web_app.app.default_host_name
}
'@

# Skriv filer per miljø
foreach ($e in $envs) {
  Set-Content "$root/environments/$e/main.tf"      $mainTf    -Encoding UTF8
  Set-Content "$root/environments/$e/variables.tf" $varsTf    -Encoding UTF8
  Set-Content "$root/environments/$e/outputs.tf"   $outputsTf -Encoding UTF8
}

# Enkle tfvars for lokal testing
@'
rg_name     = "rg-webapp-dev"
location    = "westeurope"
app_name    = "webapp-dev-REPLACE_ME"
sku         = "B1"
app_settings = {
  WELCOME_TEXT = "Hello from DEV"
}
tags = {
  env = "dev"
  app = "demo-webapp"
}
'@ | Set-Content "$root/environments/dev/dev.tfvars" -Encoding UTF8

@'
rg_name     = "rg-webapp-test"
location    = "westeurope"
app_name    = "webapp-test-REPLACE_ME"
sku         = "B1"
app_settings = {
  WELCOME_TEXT = "Hello from TEST"
}
tags = {
  env = "test"
  app = "demo-webapp"
}
'@ | Set-Content "$root/environments/test/test.tfvars" -Encoding UTF8

@'
rg_name     = "rg-webapp-prod"
location    = "westeurope"
app_name    = "webapp-prod-REPLACE_ME"
sku         = "P1v3"
app_settings = {
  WELCOME_TEXT = "Hello from PROD"
}
tags = {
  env   = "prod"
  app   = "demo-webapp"
  owner = "iac-course"
}
'@ | Set-Content "$root/environments/prod/prod.tfvars" -Encoding UTF8

Write-Host "✅ Ferdig! Strukturen er laget under ./$root"
Write-Host "Neste steg (lokalt):"
Write-Host "  cd $root/environments/dev"
Write-Host "  terraform init -backend-config='../../shared/backend.hcl' -backend-config='key=webapp/dev.tfstate'"
Write-Host "  terraform apply -var-file=dev.tfvars"
