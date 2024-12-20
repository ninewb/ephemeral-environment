locals {
  # CIDR/Network
  default_public_access_cidrs          = var.default_public_access_cidrs == null ? [] : var.default_public_access_cidrs
 
  aks_rg = (var.resource_group_name == null
    ? azurerm_resource_group.aks_rg[0]
    : data.azurerm_resource_group.aks_rg[0]
  )

  network_rg = (var.vnet_resource_group_name == null
    ? local.aks_rg
    : data.azurerm_resource_group.network_rg[0]
  )

  nsg         = var.nsg_name == null ? azurerm_network_security_group.nsg[0] : data.azurerm_network_security_group.nsg[0]
  nsg_rg_name = local.network_rg.name

}