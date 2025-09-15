param(
  [string]$BaseDir = "azure-terraform-poc"
)

$ErrorActionPreference = "Stop"
Write-Host "Oppretter struktur under: $BaseDir"

New-Item -ItemType Directory -Force -Path "$BaseDir/backend-bootstrap" | Out-Null
New-Item -ItemType Directory -Force -Path "$BaseDir/shared" | Out-Null
New-Item -ItemType Directory -Force -Path "$BaseDir/projects/vnet-sample" | Out-Null

# --- backend-bootstrap/.gitignore ---
@"
.terraform/
*.tfstate
*.tfstate.backup
crash.log
override.tf
override.tf.json
*.override.tf
*.override.tf.json
terraform.tfvars
.terraform.lock.hcl
"@ | Set-Content "$BaseDir/backend-bootstrap/.gitignore" -NoNewline

# --- backend-bootstrap/README.md ---
@"
# Backend bootstrap (Terraform state i Azure Blob)

1) Logg inn:
   az login
   az account set --subscription "<ID/navn>"

2) Init/Apply:
   terraform init
   terraform apply -auto-approve

3) Kopiér output 'backend_hcl_template' inn i ../shared/backend.hcl

4) I nye prosjekter:
   terraform init `
     -backend-config="../../shared/backend.hcl" `
     -backend-config="key=projects/vnet-sample/terraform.tfstate"
"@ | Set-Content "$BaseDir/backend-bootstrap/README.md"

# --- backend-bootstrap/versions.tf ---
@"
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
"@ | Set-Content "$BaseDir/backend-bootstrap/versions.tf"

# --- backend-bootstrap/main.tf ---
@"
provider "azurerm" {
  features {}
  use_cli = true
}

resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tfstate-${data.azurerm_client_config.current.tenant_id}"
  location = "norwayeast"
  tags = {
    purpose = "terraform-backend"
    owner   = data.azurerm_client_config.current.client_id
  }
}

resource "azurerm_storage_account" "sa" {
  name                            = "sttf${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    purpose = "terraform-backend"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "blob_contrib_current_user" {
  scope                = "${azurerm_storage_account.sa.id}/blobServices/default/containers/${azurerm_storage_container.tfstate.name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
"@ | Set-Content "$BaseDir/backend-bootstrap/main.tf"

# --- backend-bootstrap/outputs.tf ---
@"
output "backend_resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "backend_storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "backend_container_name" {
  value = azurerm_storage_container.tfstate.name
}

output "backend_hcl_template" {
  value = <<EOT
resource_group_name  = "${azurerm_resource_group.rg.name}"
storage_account_name = "${azurerm_storage_account.sa.name}"
container_name       = "${azurerm_storage_container.tfstate.name}"
use_azuread_auth     = true
use_cli              = true
EOT
}
"@ | Set-Content "$BaseDir/backend-bootstrap/outputs.tf"

# --- shared/backend.hcl ---
@"
# Lim inn verdiene fra 'terraform output backend_hcl_template' etter bootstrap.
# Eksempel:
# resource_group_name  = "rg-tfstate-<tenantId>"
# storage_account_name = "sttf<suffix>"
# container_name       = "tfstate"
# use_azuread_auth     = true
# use_cli              = true
"@ | Set-Content "$BaseDir/shared/backend.hcl"

# --- projects/vnet-sample/versions.tf ---
@"
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
  }
}
"@ | Set-Content "$BaseDir/projects/vnet-sample/versions.tf"

# --- projects/vnet-sample/backend.tf ---
@"
terraform {
  backend "azurerm" {}
}
"@ | Set-Content "$BaseDir/projects/vnet-sample/backend.tf"

# --- projects/vnet-sample/main.tf ---
@"
provider "azurerm" {
  features {}
  use_cli = true
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-lab-vnet-sample"
  location = "norwayeast"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-sample-01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.42.0.0/16"]
}
"@ | Set-Content "$BaseDir/projects/vnet-sample/main.tf"

Write-Host "Ferdig. Gå til '$BaseDir/backend-bootstrap' og kjør:"
Write-Host "  az login"
Write-Host "  az account set --subscription '<ID/navn>'"
Write-Host "  terraform init && terraform apply -auto-approve"
Write-Host "Kopiér deretter 'backend_hcl_template' inn i '$BaseDir/shared/backend.hcl'."
