# Monolithic Stack Eksempel: VM med Database og Applikasjon

# Definerer Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Ressursgruppe
resource "azurerm_resource_group" "rg" {
  name     = "monolithic-app-rg"
  location = "West Europe"
}

# Virtuelt nettverk
resource "azurerm_virtual_network" "vnet" {
  name                = "monolithic-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "monolithic-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Nettverksgrensesnitt
resource "azurerm_network_interface" "nic" {
  name                = "monolithic-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "monolithic-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Custom data for installing both database and application
  custom_data = base64encode(<<-EOF
              #!/bin/bash
              # Install MySQL
              apt-get update
              apt-get install -y mysql-server

              # Secure MySQL installation
              mysql -e "UPDATE mysql.user SET authentication_string=PASSWORD('securepassword') WHERE User='root'"
              mysql -e "DELETE FROM mysql.user WHERE User=''"
              mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
              mysql -e "DROP DATABASE IF EXISTS test"
              mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
              mysql -e "FLUSH PRIVILEGES"

              # Install Node.js and npm
              curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
              apt-get install -y nodejs

              # Create a simple Node.js application
              mkdir /app
              cat <<EOT > /app/app.js
              const express = require('express');
              const mysql = require('mysql');
              const app = express();
              const port = 3000;

              const connection = mysql.createConnection({
                host: 'localhost',
                user: 'root',
                password: 'securepassword',
                database: 'testdb'
              });

              connection.connect();

              app.get('/', (req, res) => {
                connection.query('SELECT 1 + 1 AS solution', (error, results, fields) => {
                  if (error) throw error;
                  res.send('The solution is: ' + results[0].solution);
                });
              });

              app.listen(port, () => {
                console.log(`App listening at http://localhost:${port}`);
              });
              EOT

              # Install application dependencies
              cd /app
              npm init -y
              npm install express mysql

              # Start the application
              npm install -g pm2
              pm2 start app.js
              pm2 startup systemd
              pm2 save

              EOF
  )
}

# Nettverkssikkerhetsgruppe
resource "azurerm_network_security_group" "nsg" {
  name                = "monolithic-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
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
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Koble nettverkssikkerhetsgruppen til nettverksgrensesnittet
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}