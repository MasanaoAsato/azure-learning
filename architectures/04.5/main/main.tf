module "resource_group" {
  source = "../modules/resource_group"
}

module "network" {
  source                          = "../modules/network"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix

  depends_on = [module.resource_group]
}

module "bastion" {
  source                          = "../modules/bastion"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  bastion_subnet_id               = module.network.bastion_subnet_id
  prefix                          = local.prefix
  bastion_sku                     = local.bastion_sku

  depends_on = [module.network]
}

module "vm" {
  source                          = "../modules/vm"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
  subnet_spoke1_id                = module.network.subnet_spoke1_id
  bastion_subnet_ip_prefixes      = module.network.bastion_subnet_ip_prefixes
  vm_size                         = local.vm_size
  vm_storage_account_type         = local.vm_storage_account_type
  admin_username                  = local.admin_username

  depends_on = [module.network, module.bastion]
}

module "database" {
  source                          = "../modules/database"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
  db_sku_name                     = local.db_sku_name

  depends_on = [module.resource_group]
}

module "private_endpoint" {
  source                          = "../modules/private_endpoint"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
  pe_subnet_id                    = module.network.subnet_spoke1_pe_id
  postgresql_server_id            = module.database.postgresql_server_id
  private_dns_zone_postgresql_id  = module.network.private_dns_zone_postgresql_id

  depends_on = [module.network, module.database]
}
