resource "azurerm_public_ip" "pip" {
  count               = var.allocate_public_ip ? 1 : 0
  name                = "pip-${var.environment}-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.environment}-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.allocate_public_ip ? azurerm_public_ip.pip[0].id : null
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.environment}-${var.name_prefix}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name = "vm-${var.environment}"
  tags          = var.tags
}
