#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-azure-terraform-poc}"

echo "Oppretter struktur under: ${BASE_DIR}"

# Lag kataloger
mkdir -p "${BASE_DIR}/backend-bootstrap"
mkdir -p "${BASE_DIR}/shared"
mkdir -p "${BASE_DIR}/projects/vnet-sample"

# ---------- backend-bootstrap/.gitignore ----------
cat > "${BASE_DIR}/backend-bootstrap/.gitignore" <<'EOF'
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
EOF

# ---------- backend-bootstrap/README.md ----------
cat > "${BASE_DIR}/backend-bootstrap/README.md" <<'EOF'
# Backend bootstrap (Terraform state i Azure Blob)

1) Logg inn:
   az login
   az account set --subscription "<ID/navn>"

2) Init/Apply:
   terraform init
   terraform apply -auto-approve

3) Kopiér output 'backend_hcl_template' inn i ../shared/backend.hcl

4) I nye prosjekter:
   terraform init \
     -backend-config="../../shared/backend.hcl" \
     -backend-config="key=projects/vnet-sample/terraform.tfstate"
EOF

# ---------- backend-bootstrap/versions.tf ----------
cat > "${BASE_DIR}/backend-bootstrap/versions.tf" <<'EOF'
terraform {
  required_version = ">= 1.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.42.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
EOF

# ---------- backend-bootstrap/main.tf ----------
cat > "${BASE_DIR}/backend-bootstrap/main.tf" <<'EOF'
provider "azurerm" {
  features {
  }
  storage_use_azuread = true
  subscription_id     = "a3adf20e-4966-4afb-b717-4de1baae6db1"
  use_cli             = true
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
  name     = "rg-tfstate-${random_string.suffix.result}"
  location = "norwayeast"
  tags = {
    purpose = "terraform-backend"
    owner   = data.azurerm_client_config.current.object_id
  }
}

resource "azurerm_storage_account" "sa" {
  name                            = "sttf${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  allow_nested_items_to_be_public = false

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
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# Tildel data-rolle til innlogget bruker på STORAGE-KONTO-nivå
# Dette dekker både listing av containere og listing/lesing/skriving av blobs.
resource "azurerm_role_assignment" "blob_contrib_self_account_scope" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"

  # Sørg for at kontoen er ferdig opprettet før RBAC forsøkes
  depends_on = [
    azurerm_storage_account.sa,
    azurerm_storage_container.tfstate
  ]
}
EOF

# ---------- backend-bootstrap/outputs.tf ----------
cat > "${BASE_DIR}/backend-bootstrap/outputs.tf" <<'EOF'
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
EOF

# ---------- shared/backend.hcl (plassholder) ----------
cat > "${BASE_DIR}/shared/backend.hcl" <<'EOF'
# Lim inn verdiene fra 'terraform output backend_hcl_template' etter bootstrap.
# Eksempel:
# resource_group_name  = "rg-tfstate-<suffix>"
# storage_account_name = "sttf<suffix>"
# container_name       = "tfstate"
# use_azuread_auth     = true
# use_cli              = true
EOF

# ---------- projects/vnet-sample/versions.tf ----------
cat > "${BASE_DIR}/projects/vnet-sample/versions.tf" <<'EOF'
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
  }
}
EOF

# ---------- projects/vnet-sample/backend.tf ----------
cat > "${BASE_DIR}/projects/vnet-sample/backend.tf" <<'EOF'
terraform {
  backend "azurerm" {}
}
EOF

# ---------- projects/vnet-sample/main.tf ----------
cat > "${BASE_DIR}/projects/vnet-sample/main.tf" <<'EOF'
provider "azurerm" {
  features {}
  subscription_id = "" # Sett riktig subscription_id her eller via env var
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

EOF

echo "Ferdig. Gå til '${BASE_DIR}/backend-bootstrap' og kjør:"
echo "  az login"
echo "  az account set --subscription \"<ID/navn>\""
echo "  terraform init && terraform apply -auto-approve"
echo "Kopiér deretter 'backend_hcl_template' inn i '${BASE_DIR}/shared/backend.hcl'."
