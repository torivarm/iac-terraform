#!/usr/bin/env bash
set -e

mkdir -p environments/{dev,test,prod} stacks modules/resourcegroup

# Module
cat > modules/resourcegroup/main.tf <<'EOF'
resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
}
EOF

cat > modules/resourcegroup/variables.tf <<'EOF'
variable "rg_name" {
  type        = string
  description = "Navnet på resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}
EOF

cat > modules/resourcegroup/outputs.tf <<'EOF'
output "rg_name" {
  value = azurerm_resource_group.this.name
}
EOF

# Environment template
for ENV in dev test prod; do
  cat > environments/$ENV/main.tf <<'EOF'
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
EOF

  cat > environments/$ENV/variables.tf <<'EOF'
variable "rg_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}
EOF

  cat > environments/$ENV/outputs.tf <<'EOF'
output "rg_name" {
  value = module.rg.rg_name
}
EOF

  cat > environments/$ENV/$ENV.tfvars <<EOF
rg_name = "rg-$ENV"
location = "westeurope"
EOF
done

# Stacks
cat > stacks/main.tf <<'EOF'
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
EOF

touch stacks/variables.tf stacks/outputs.tf

echo "✅ Struktur og filer opprettet."
