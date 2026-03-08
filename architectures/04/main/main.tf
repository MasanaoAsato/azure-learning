module "resource_group" {
  source = "../modules/resource_group"
}

module "network" {
  source = "../modules/network"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
}

module "vm" {
  source = "../modules/vm"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
  subnet_spoke1_id                = module.network.subnet_spoke1_id
  subnet_spoke2_id                = module.network.subnet_spoke2_id
  vm_size                         = local.vm_size
  vm_storage_account_type         = local.vm_storage_account_type
  admin_username                  = local.admin_username
}
