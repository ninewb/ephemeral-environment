terraform {
  required_providers {
    tailscale = {
      source = "tailscale/tailscale"
      version = "~> 0.13"
    }
  }
}

provider "cloudinit" {}

provider "tailscale" {
  tailnet = "tail9d499.ts.net"
}

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

resource "azurerm_network_security_rule" "tailscale" {
  name                        = "Tailscale"
  description                 = "Tailscale UDP port for direct connections. Reduces latency."
  count                       = (length(var.public_access_cidrs) > 0 ? 1 : 0)
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = 41641
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
  admin_username                  = var.virtual_machine_userid
  admin_password                  = var.virtual_machine_password
  disable_password_authentication = false

  custom_data = data.cloudinit_config.cloudinit.rendered
}

data "cloudinit_config" "cloudinit" {
  base64_encode = true
  gzip          = true
  part {
    content_type = "text/cloud-config"
    content      = file("tailscale/cloudinit.yml")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("tailscale/cloudinit.sh", {
      tailscale_auth_key = var.tailscale_auth_key
    })
  }
}

