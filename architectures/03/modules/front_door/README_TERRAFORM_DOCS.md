<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

- <a name="provider_random"></a> [random](#provider\_random)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_cdn_frontdoor_endpoint.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) (resource)
- [azurerm_cdn_frontdoor_firewall_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy) (resource)
- [azurerm_cdn_frontdoor_origin.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) (resource)
- [azurerm_cdn_frontdoor_origin_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) (resource)
- [azurerm_cdn_frontdoor_profile.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) (resource)
- [azurerm_cdn_frontdoor_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) (resource)
- [azurerm_cdn_frontdoor_security_policy.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_security_policy) (resource)
- [random_string.endpoint_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_default_name"></a> [resource\_group\_default\_name](#input\_resource\_group\_default\_name)

Description: The name of the resource group default

Type: `string`

### <a name="input_storage_primary_web_host"></a> [storage\_primary\_web\_host](#input\_storage\_primary\_web\_host)

Description: The hostname of the storage account static website

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_latency_in_milliseconds"></a> [additional\_latency\_in\_milliseconds](#input\_additional\_latency\_in\_milliseconds)

Description: The additional latency in milliseconds for the Front Door CDN origin

Type: `number`

Default: `0`

### <a name="input_frontdoor_cdn_priority"></a> [frontdoor\_cdn\_priority](#input\_frontdoor\_cdn\_priority)

Description: The priority of the Front Door CDN origin

Type: `number`

Default: `1`

### <a name="input_frontdoor_cdn_weight"></a> [frontdoor\_cdn\_weight](#input\_frontdoor\_cdn\_weight)

Description: The weight of the Front Door CDN origin

Type: `number`

Default: `1`

### <a name="input_health_probe_interval_in_seconds"></a> [health\_probe\_interval\_in\_seconds](#input\_health\_probe\_interval\_in\_seconds)

Description: The interval in seconds for the health probe

Type: `number`

Default: `60`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

### <a name="input_response_timeout_seconds"></a> [response\_timeout\_seconds](#input\_response\_timeout\_seconds)

Description: The response timeout in seconds for the Front Door CDN profile

Type: `number`

Default: `60`

## Outputs

The following outputs are exported:

### <a name="output_frontdoor_ep_hostname"></a> [frontdoor\_ep\_hostname](#output\_frontdoor\_ep\_hostname)

Description: The hostname of the Front Door endpoint
<!-- END_TF_DOCS -->