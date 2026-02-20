module "resource_group" {
  source = "../modules/resource_group"
}

module "container_registry" {
  source                          = "../modules/container_registry"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
}

module "container_apps" {
  source                          = "../modules/container_apps"
  resource_group_default_name     = module.resource_group.resource_group_default_name
  resource_group_default_location = module.resource_group.resource_group_default_location
  prefix                          = local.prefix
  capps_cpu                       = local.capps_cpu
  capps_memory                    = local.capps_memory
  capps_min_replicas              = local.capps_min_replicas
  capps_max_replicas              = local.capps_max_replicas
  capps_scale_concurrent_requests = local.capps_scale_concurrent_requests
}
