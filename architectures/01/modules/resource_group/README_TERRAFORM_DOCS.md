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

- [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

## Outputs

The following outputs are exported:

### <a name="output_resource_group_default_location"></a> [resource\_group\_default\_location](#output\_resource\_group\_default\_location)

Description: The location of the resource group default

### <a name="output_resource_group_default_name"></a> [resource\_group\_default\_name](#output\_resource\_group\_default\_name)

Description: The name of the resource group default
<!-- END_TF_DOCS -->