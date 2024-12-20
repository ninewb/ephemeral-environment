module "vm" {
  source = "./modules/azurerm_vm"

  count                      = var.create_vm ? 1 : 0
  name                       = "${var.prefix}-vm"
  azure_rg_name              = local.aks_rg.name
  azure_rg_location          = var.location
  vnet_subnet_id             = module.vnet.subnets["misc"].id
  machine_type               = var.vm_machine_type
  azure_nsg_id               = local.nsg.id
  tags                       = var.tags
  db_disk_size               = var.db_disk_size
  vm_admin                   = var.vm_admin
  vm_zone                    = var.vm_zone
  fips_enabled               = var.fips_enabled
  ssh_public_key             = local.ssh_public_key
  create_public_ip           = var.create_public_ip
  enable_public_static_ip    = var.enable_public_static_ip
  encryption_at_host_enabled = var.enable_vm_host_encryption
  disk_encryption_set_id     = var.vm_disk_encryption_set_id
  depends_on = [module.vnet]
}