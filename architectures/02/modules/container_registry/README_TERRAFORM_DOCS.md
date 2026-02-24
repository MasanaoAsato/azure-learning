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

- [azurerm_container_registry.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) (resource)
- [random_string.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

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

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->