#!/usr/bin/env bash
set -euo pipefail

# =====================================================================
# Terraform Azure scaffold – RG opprettes i environments (dev/test/prod)
# Moduler er gjenbrukbare, stacks syr dem sammen, environments eier RG.
# =====================================================================

root_dir="$(pwd)"

# Kataloger
mkdir -p "./modules/network"
mkdir -p "./modules/compute-vm"
mkdir -p "./stacks"
mkdir -p "./environments/dev"
mkdir -p "./environments/test"
mkdir -p "./environments/prod"

# --------------------------
# modules/network
# --------------------------
cat > ./modules/network/variables.tf <<'EOF'
variable "name_prefix" {
  description = "Kort prefiks for ressursnavn (f.eks. 'demo')."
  type        = string
}

variable "location" {
  description = "Azure location (f.eks. 'westeurope')."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG der nettverk skal ligge."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR for subnets i VNet. Første brukes til VM."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "tags" {
  description = "Standard tags å sette på ressurser."
  type        = map(string)
  default     = {}
}
EOF

cat > ./modules/network/main.tf <<'EOF'
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  vnet_name   = "${var.name_prefix}-vnet"
  subnet_name = "${var.name_prefix}-subnet1"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = local.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefixes[0]]
}
EOF

cat > ./modules/network/outputs.tf <<'EOF'
output "vnet_id" {
  description = "ID for VNet."
  value       = azurerm_virtual_network.this.id
}

output "subnet_id" {
  description = "ID for første subnet."
  value       = azurerm_subnet.this.id
}
EOF

# --------------------------
# modules/compute-vm
# --------------------------
cat > ./modules/compute-vm/variables.tf <<'EOF'
variable "name_prefix" {
  description = "Kort prefiks for ressursnavn."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG (må eksistere)."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID der NIC skal kobles."
  type        = string
}

variable "vm_size" {
  description = "Størrelse på VM."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Adminbruker på VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key-innhold."
  type        = string
}

variable "enable_public_ip" {
  description = "Opprett Public IP?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Standard tags."
  type        = map(string)
  default     = {}
}
EOF

cat > ./modules/compute-vm/main.tf <<'EOF'
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  nic_name    = "${var.name_prefix}-nic"
  pip_name    = "${var.name_prefix}-pip"
  vm_name     = "${var.name_prefix}-vm"
  nsg_name    = "${var.name_prefix}-nsg"
  cloud_init  = <<-CLOUD
              #cloud-config
              package_update: true
              packages:
                - nginx
              runcmd:
                - systemctl enable nginx
                - systemctl start nginx
              CLOUD
}

resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip ? 1 : 0
  name                = local.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "this" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipcfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.this[0].id : null
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = local.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(local.cloud_init)

  tags = var.tags
}
EOF

cat > ./modules/compute-vm/outputs.tf <<'EOF'
output "vm_id" {
  description = "ID for VM."
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip" {
  description = "Privat IP."
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip" {
  description = "Offentlig IP (tom dersom slått av)."
  value       = try(azurerm_public_ip.this[0].ip_address, null)
}
EOF

# --------------------------
# stacks (komposisjon av moduler) – nå U/T RG
# --------------------------
cat > ./stacks/variables.tf <<'EOF'
variable "environment" {
  description = "Miljønavn (dev/test/prod)."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Prefiks for navngiving (korte, konsise)."
  type        = string
}

variable "resource_group_name" {
  description = "Navn på RG som eies av environment."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR for subnets."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "vm_size" {
  description = "VM-størrelse."
  type        = string
  default     = "Standard_B2s"
}

variable "ssh_public_key" {
  description = "SSH public key-innhold for VM-innlogging."
  type        = string
}

variable "enable_public_ip" {
  description = "Opprett Public IP for VM?"
  type        = bool
  default     = true
}
EOF

cat > ./stacks/main.tf <<'EOF'
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  # Konsis navnestandard: <prefix>-<env>-<res>
  name_prefix = "${var.name_prefix}-${var.environment}"

  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
    iac_stack   = "base"
  }
}

module "network" {
  source              = "../modules/network"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = local.common_tags
}

module "compute_vm" {
  source              = "../modules/compute-vm"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.subnet_id
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  enable_public_ip    = var.enable_public_ip
  tags                = local.common_tags
}
EOF

cat > ./stacks/outputs.tf <<'EOF'
output "resource_group_name" {
  description = "Navn på RG."
  value       = var.resource_group_name
}

output "vnet_id" {
  description = "ID til VNet."
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "ID til Subnet."
  value       = module.network.subnet_id
}

output "vm_id" {
  description = "ID for VM."
  value       = module.compute_vm.vm_id
}

output "vm_private_ip" {
  description = "Privat IP for VM."
  value       = module.compute_vm.private_ip
}

output "vm_public_ip" {
  description = "Offentlig IP for VM (om aktivert)."
  value       = module.compute_vm.public_ip
}
EOF

# --------------------------
# environments/* (root modules) – EIER RG
# --------------------------
create_env () {
  env="$1"
  tfvars="$2"

  cat > "./environments/${env}/variables.tf" <<'EOF'
variable "environment" {
  description = "Miljønavn."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Prefiks for navngiving."
  type        = string
}

variable "address_space" {
  description = "Adressområde for VNet."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "CIDR for subnets."
  type        = list(string)
}

variable "vm_size" {
  description = "VM-størrelse."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key-innhold."
  type        = string
}

variable "enable_public_ip" {
  description = "Opprett Public IP?"
  type        = bool
}
EOF

  cat > "./environments/${env}/main.tf" <<'EOF'
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }

  backend "azurerm" {
    # Sett disse via -backend-config ved terraform init (anbefalt):
    # resource_group_name  =
    # storage_account_name =
    # container_name       =
    # key                  =
  }
}

provider "azurerm" {
  features {}
}

# Environment eier Resource Group
locals {
  env_prefix = "${var.name_prefix}-${var.environment}"
  env_tags = {
    environment = var.environment
    managed_by  = "terraform"
    owner       = "platform-team"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.env_prefix}-rg"
  location = var.location
  tags     = local.env_tags
}

module "stack" {
  source              = "../../stacks"
  environment         = var.environment
  location            = var.location
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg.name

  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  vm_size             = var.vm_size
  ssh_public_key      = var.ssh_public_key
  enable_public_ip    = var.enable_public_ip
}
EOF

  cat > "./environments/${env}/outputs.tf" <<'EOF'
output "resource_group_name" {
  value       = module.stack.resource_group_name
  description = "Navn på RG i dette miljøet."
}

output "vm_private_ip" {
  value       = module.stack.vm_private_ip
  description = "Privat IP for VM."
}

output "vm_public_ip" {
  value       = module.stack.vm_public_ip
  description = "Offentlig IP for VM (om aktivert)."
}
EOF

  cat > "./environments/${env}/${tfvars}" <<EOF
# Verdier for ${env}
environment      = "${env}"
location         = "westeurope"
name_prefix      = "demo"

address_space    = ["10.${RANDOM%200}.0.0/16"]
subnet_prefixes  = ["10.${RANDOM%200}.1.0/24"]

vm_size          = "Standard_B2s"
ssh_public_key   = chomp(file("~/.ssh/id_rsa.pub"))
enable_public_ip = true
EOF
}

create_env "dev"  "dev.tfvars"
create_env "test" "test.tfvars"
create_env "prod" "prod.tfvars"

# --------------------------
# README
# --------------------------
cat > ./README.md <<'EOF'
# Terraform Azure – RG i environments (dev/test/prod)

Struktur:
- `modules/` – gjenbrukbare moduler (nettverk, VM).
- `stacks/` – komposisjon av moduler til en deploybar stack (uten RG).
- `environments/{dev,test,prod}` – **root modules** som eier Resource Group, backend, provider og kaller stacken.

## Første gangs kjøring (eksempel: dev)
```bash
cd environments/dev

terraform init \
  -backend-config="resource_group_name=<RG_FOR_TFSTATE>" \
  -backend-config="storage_account_name=<STORAGE_ACCOUNT>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=demo/dev.tfstate"

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
