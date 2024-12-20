provider "cloudinit" {}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "default" {
  name     = var.resource_group
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "default" {
  name                = "${var.prefix}-vnet"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.prefix}-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_network_security_rule" "default" {
  name                        = "${var.prefix}-ssh"
  description                 = "Allow SSH from source"
  count                       = (length(var.public_access_cidrs) > 0 ? 1 : 0)
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.public_access_cidrs
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_public_ip" "server" {
  name                = "${var.prefix}-pip"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_network_interface" "server" {
  name                = "${var.prefix}-inet"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.default.name
  
  ip_configuration {
    name                          = "${var.prefix}-ip"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    public_ip_address_id          = azurerm_public_ip.server.id
  }
}

resource "azurerm_network_interface_security_group_association" "server" {
  network_interface_id      = azurerm_network_interface.server.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_linux_virtual_machine" "server" {
  name                  = "${var.prefix}-vm"
  location              = var.resource_group_location
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [azurerm_network_interface.server.id]
  size                  = var.virtual_machine_size
  admin_username        = var.virtual_machine_userid
  tags                  = var.tags
  zone                  = 1

  os_disk {
    name                 = "${var.prefix}-disk"
    disk_size_gb         = var.virtual_machine_disk_size
    caching              = "ReadWrite"
    storage_account_type = var.virtual_machine_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = var.prefix
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.virtual_machine_userid
    public_key = file("${var.public_key}")
  }
}

data "cloudinit_config" "cloudinit" {
  base64_encode = true
  gzip          = true
  part {
    content_type = "text/cloud-config"
    content      = file("cloudinit/cloudinit.yml")
  }
}

