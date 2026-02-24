<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_confidential_app.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/confidential_app) (resource)
- [azurerm_container_app_environment.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_default_location"></a> [resource\_group\_default\_location](#input\_resource\_group\_default\_location)

Description: The location of the resource group default

Type: `string`

### <a name="input_resource_group_default_name"></a> [resource\_group\_default\_name](#input\_resource\_group\_default\_name)

Description: The name of the resource group default

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_capps_cpu"></a> [capps\_cpu](#input\_capps\_cpu)

Description: CPU for container apps

Type: `number`

Default: `0.5`

### <a name="input_capps_max_replicas"></a> [capps\_max\_replicas](#input\_capps\_max\_replicas)

Description: Maximum number of replicas for container apps

Type: `number`

Default: `3`

### <a name="input_capps_memory"></a> [capps\_memory](#input\_capps\_memory)

Description: Memory for container apps

Type: `string`

Default: `"0.5Gi"`

### <a name="input_capps_min_replicas"></a> [capps\_min\_replicas](#input\_capps\_min\_replicas)

Description: Minimum number of replicas for container apps

Type: `number`

Default: `0`

### <a name="input_capps_scale_concurrent_requests"></a> [capps\_scale\_concurrent\_requests](#input\_capps\_scale\_concurrent\_requests)

Description: Concurrent requests for container apps scale rule

Type: `number`

Default: `10`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->