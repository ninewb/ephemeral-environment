provider "azurerm" {

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  partner_id      = var.partner_id
  use_msi         = var.use_msi

  features {}
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "network_rg" {
  count = var.vnet_resource_group_name == null ? 0 : 1
  name  = var.vnet_resource_group_name
}

resource "azurerm_proximity_placement_group" "proximity" {
  count = var.node_pools_proximity_placement ? 1 : 0

  name                = "${var.prefix}-ProximityPlacementGroup"
  location            = var.location
  resource_group_name = local.aks_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  count               = var.nsg_name == null ? 1 : 0
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = local.network_rg.name
  tags                = var.tags
}

data "azurerm_network_security_group" "nsg" {
  count               = var.nsg_name == null ? 0 : 1
  name                = var.nsg_name
  resource_group_name = local.network_rg.name
}

data "azurerm_public_ip" "nat-ip" {
  count               = var.egress_public_ip_name == null ? 0 : 1
  name                = var.egress_public_ip_name
  resource_group_name = local.network_rg.name
}

module "vnet" {
  source = "./modules/azurerm_vnet"

  name                = var.vnet_name
  prefix              = var.prefix
  resource_group_name = local.network_rg.name
  location            = var.location
  subnets             = local.subnets
  existing_subnets    = var.subnet_names
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}