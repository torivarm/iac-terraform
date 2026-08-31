#!/usr/bin/env bash
set -euo pipefail

ROOT="terraform-projects"
ENV_DIRS=("dev" "test" "prod")

# Mapper
mkdir -p "$ROOT/shared"
for e in "${ENV_DIRS[@]}"; do
  mkdir -p "$ROOT/environments/$e"
done

# ---------------- shared/backend.hcl ----------------
cat > "$ROOT/shared/backend.hcl" <<'HCL'
# Fyll inn verdier som peker til eksisterende state-konto/container
resource_group_name  = "rg-tfstate-REPLACE_ME"
storage_account_name = "sttfstateREPLACE"
container_name       = "tfstate"
use_azuread_auth     = true
HCL

# ---------------- felles Terraform-innhold ----------------
cat > "$ROOT/environments/dev/dev.tfvars" <<'TFV'
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
TFV

cat > "$ROOT/environments/test/test.tfvars" <<'TFV'
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
TFV

cat > "$ROOT/environments/prod/prod.tfvars" <<'TFV'
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
TFV

# Innhold for main.tf (korrekt provider-format)
read -r -d '' MAIN_TF <<'HCL'
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

# 1) Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

# 2) App Service Plan (Linux)
resource "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags                = var.tags
}

# 3) Linux Web App
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
      # Alternativer:
      # python_version = "3.11"
      # dotnet_version = "8.0"
    }
  }

  app_settings = var.app_settings
}
HCL

# Innhold for variables.tf (hver variabel i flermlinjeformat)
read -r -d '' VARS_TF <<'HCL'
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
HCL

# Innhold for outputs.tf
read -r -d '' OUTPUTS_TF <<'HCL'
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
HCL

# Skriv filer til alle miljøer
for e in "${ENV_DIRS[@]}"; do
  printf "%s\n" "$MAIN_TF"    > "$ROOT/environments/$e/main.tf"
  printf "%s\n" "$VARS_TF"    > "$ROOT/environments/$e/variables.tf"
  printf "%s\n" "$OUTPUTS_TF" > "$ROOT/environments/$e/outputs.tf"
done

echo "✅ Ferdig! Strukturen er laget under ./$ROOT"
echo "Neste steg (lokalt):"
echo "  cd $ROOT/environments/dev"
echo "  terraform init -backend-config='../../shared/backend.hcl' -backend-config='key=webapp/dev.tfstate'"
echo "  terraform apply -var-file=dev.tfvars"
