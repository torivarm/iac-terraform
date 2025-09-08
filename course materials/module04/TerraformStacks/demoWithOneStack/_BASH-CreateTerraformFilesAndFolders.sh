#!/usr/bin/env bash
set -euo pipefail

# Dette skriptet oppretter en katalogstruktur og tomme Terraform-filer for et prosjekt med moduler og miljøer.
# chmod +x <filename>.sh, og skriptet kan kjøres med ./<filename>.sh

# Kataloger
mkdir -p "./modules/network"
mkdir -p "./modules/compute-vm"
mkdir -p "./stacks"
mkdir -p "./environments/dev"
mkdir -p "./environments/test"
mkdir -p "./environments/prod"

# Filer for modules/network
touch "./modules/network/main.tf"
touch "./modules/network/variables.tf"
touch "./modules/network/outputs.tf"

# Filer for modules/compute-vm
touch "./modules/compute-vm/main.tf"
touch "./modules/compute-vm/variables.tf"
touch "./modules/compute-vm/outputs.tf"

# Filer for stacks
touch "./stacks/main.tf"
touch "./stacks/variables.tf"
touch "./stacks/outputs.tf"

# Filer for environments/dev
touch "./environments/dev/main.tf"
touch "./environments/dev/variables.tf"
touch "./environments/dev/dev.tfvars"
touch "./environments/dev/backend.tf"

# Filer for environments/test
touch "./environments/test/main.tf"
touch "./environments/test/variables.tf"
touch "./environments/test/test.tfvars"
touch "./environments/test/backend.tf"

# Filer for environments/prod
touch "./environments/prod/main.tf"
touch "./environments/prod/variables.tf"
touch "./environments/prod/prod.tfvars"
touch "./environments/prod/backend.tf"

echo "Struktur opprettet i: $(pwd)"
