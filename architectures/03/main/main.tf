module "resource_group" {
  source = "../modules/resource_group"
}

module "storage_account" {
  source                          = "../modules/storage_account"
  prefix                          = local.prefix
  resource_group_default_location = module.resource_group.resource_group_default_location
  resource_group_default_name     = module.resource_group.resource_group_default_name

  depends_on = [module.resource_group]
}

module "front_door" {
  source                          = "../modules/front_door"
  prefix                          = local.prefix
  resource_group_default_name     = module.resource_group.resource_group_default_name
  storage_primary_web_host        = module.storage_account.primary_web_host

  frontdoor_cdn_priority             = local.frontdoor_cdn_priority
  frontdoor_cdn_weight               = local.frontdoor_cdn_weight
  additional_latency_in_milliseconds = local.additional_latency_in_milliseconds
  health_probe_interval_in_seconds   = local.health_probe_interval_in_seconds
  response_timeout_seconds           = local.response_timeout_seconds

  depends_on = [module.storage_account]
}
