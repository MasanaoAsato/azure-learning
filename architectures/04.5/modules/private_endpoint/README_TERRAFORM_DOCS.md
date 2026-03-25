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

- [azurerm_private_endpoint.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_pe_subnet_id"></a> [pe\_subnet\_id](#input\_pe\_subnet\_id)

Description: The ID of the subnet for Private Endpoints

Type: `string`

### <a name="input_postgresql_server_id"></a> [postgresql\_server\_id](#input\_postgresql\_server\_id)

Description: The ID of the PostgreSQL Flexible Server to connect via Private Endpoint

Type: `string`

### <a name="input_private_dns_zone_postgresql_id"></a> [private\_dns\_zone\_postgresql\_id](#input\_private\_dns\_zone\_postgresql\_id)

Description: The ID of the private DNS zone for PostgreSQL

Type: `string`

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

The following outputs are exported:

### <a name="output_private_endpoint_ip"></a> [private\_endpoint\_ip](#output\_private\_endpoint\_ip)

Description: The private IP address of the PostgreSQL Private Endpoint
<!-- END_TF_DOCS -->