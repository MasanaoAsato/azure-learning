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

- [azurerm_private_dns_zone.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone_virtual_network_link.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) (resource)
- [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_default_location"></a> [resource\_group\_default\_location](#input\_resource\_group\_default\_location)

Description: The location of the resource group default

Type: `string`

### <a name="input_resource_group_default_name"></a> [resource\_group\_default\_name](#input\_resource\_group\_default\_name)

Description: The name of the resource group default

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_azure_subnet_postgresql_id"></a> [azure\_subnet\_postgresql\_id](#output\_azure\_subnet\_postgresql\_id)

Description: The ID of the PostgreSQL subnet

### <a name="output_bastion_subnet_id"></a> [bastion\_subnet\_id](#output\_bastion\_subnet\_id)

Description: The ID of the Bastion subnet

### <a name="output_jumpbox_subnet_id"></a> [jumpbox\_subnet\_id](#output\_jumpbox\_subnet\_id)

Description: The ID of the jumpbox subnet

### <a name="output_private_dns_zone_postgresql_id"></a> [private\_dns\_zone\_postgresql\_id](#output\_private\_dns\_zone\_postgresql\_id)

Description: The ID of the PostgreSQL private DNS zone

### <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name)

Description: The name of the virtual network

### <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id)

Description: The ID of the virtual network
<!-- END_TF_DOCS -->