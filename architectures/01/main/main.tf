module "resource_group" {
  source = "../modules/resource_group"
  prefix = local.prefix
}

module "network" {
  source                          = "../modules/network"
  prefix                          = local.prefix
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
}

module "database" {
  source                          = "../modules/database"
  prefix                          = local.prefix
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  azure_subnet_postgresql_id      = module.network.azure_subnet_postgresql_id
  private_dns_zone_postgresql_id  = module.network.private_dns_zone_postgresql_id
  db_storage                      = local.db_storage
  db_sku_name                     = local.db_sku_name
  db_backup_retention_days        = local.db_backup_retention_days
  db_version                      = local.db_version

  depends_on = [module.network]
}

module "bastion" {
  source              = "../modules/bastion"
  prefix              = local.prefix
  resource_group_name = module.resource_group.resource_group_default_name
  location            = module.resource_group.resource_group_default_location
  bastion_subnet_id   = module.network.bastion_subnet_id
  bastion_sku         = local.bastion_sku

  depends_on = [module.network]
}

module "jumpbox" {
  source                  = "../modules/jumpbox"
  prefix                  = local.prefix
  resource_group_name     = module.resource_group.resource_group_default_name
  location                = module.resource_group.resource_group_default_location
  jumpbox_subnet_id       = module.network.jumpbox_subnet_id
  vm_size                 = local.vm_size
  admin_username          = local.admin_username
  vm_storage_account_type = local.vm_storage_account_type

  depends_on = [module.network, module.bastion]
}
