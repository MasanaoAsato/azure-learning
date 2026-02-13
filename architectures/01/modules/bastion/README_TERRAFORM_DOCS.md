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

- [azurerm_bastion_host.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) (resource)
- [azurerm_network_security_group.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_subnet_network_security_group_association.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_bastion_subnet_id"></a> [bastion\_subnet\_id](#input\_bastion\_subnet\_id)

Description: The ID of the Bastion subnet

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku)

Description: The SKU of the Azure Bastion Host

Type: `string`

Default: `"Standard"`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

## Outputs

The following outputs are exported:

### <a name="output_bastion_dns_name"></a> [bastion\_dns\_name](#output\_bastion\_dns\_name)

Description: The DNS name of the Azure Bastion

### <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id)

Description: The ID of the Azure Bastion

### <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip)

Description: The public IP address of the Azure Bastion
<!-- END_TF_DOCS -->