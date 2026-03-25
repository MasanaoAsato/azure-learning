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

- [azurerm_firewall.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) (resource)
- [azurerm_firewall_policy.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) (resource)
- [azurerm_firewall_policy_rule_collection_group.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) (resource)
- [azurerm_private_dns_zone.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone_virtual_network_link.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) (resource)
- [azurerm_public_ip.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_route_table.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [azurerm_subnet.hub-bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.hub-fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.spoke1-pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.spoke1-vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_route_table_association.spoke1-vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_virtual_network.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network_peering.hub-spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)
- [azurerm_virtual_network_peering.spoke1-hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)

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

The following outputs are exported:

### <a name="output_bastion_subnet_id"></a> [bastion\_subnet\_id](#output\_bastion\_subnet\_id)

Description: The ID of the bastion subnet

### <a name="output_bastion_subnet_ip_prefixes"></a> [bastion\_subnet\_ip\_prefixes](#output\_bastion\_subnet\_ip\_prefixes)

Description: The address prefixes of the bastion subnet

### <a name="output_private_dns_zone_postgresql_id"></a> [private\_dns\_zone\_postgresql\_id](#output\_private\_dns\_zone\_postgresql\_id)

Description: The ID of the private DNS zone for PostgreSQL

### <a name="output_private_dns_zone_postgresql_name"></a> [private\_dns\_zone\_postgresql\_name](#output\_private\_dns\_zone\_postgresql\_name)

Description: The name of the private DNS zone for PostgreSQL

### <a name="output_spoke1_subnet_ip_prefixes"></a> [spoke1\_subnet\_ip\_prefixes](#output\_spoke1\_subnet\_ip\_prefixes)

Description: The address prefixes of the spoke1 subnet for VMs

### <a name="output_subnet_spoke1_id"></a> [subnet\_spoke1\_id](#output\_subnet\_spoke1\_id)

Description: The ID of the spoke1 subnet for VMs

### <a name="output_subnet_spoke1_pe_id"></a> [subnet\_spoke1\_pe\_id](#output\_subnet\_spoke1\_pe\_id)

Description: The ID of the spoke1 subnet for Private Endpoints
<!-- END_TF_DOCS -->