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

- [azurerm_linux_virtual_machine.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)
- [azurerm_network_interface.spoke1-vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_network_security_group.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_subnet_network_security_group_association.spoke1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [random_password.admin_password_spoke1](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_bastion_subnet_ip_prefixes"></a> [bastion\_subnet\_ip\_prefixes](#input\_bastion\_subnet\_ip\_prefixes)

Description: The address prefixes of the bastion subnet

Type: `list(string)`

### <a name="input_resource_group_default_location"></a> [resource\_group\_default\_location](#input\_resource\_group\_default\_location)

Description: The location of the resource group default

Type: `string`

### <a name="input_resource_group_default_name"></a> [resource\_group\_default\_name](#input\_resource\_group\_default\_name)

Description: The name of the resource group default

Type: `string`

### <a name="input_subnet_spoke1_id"></a> [subnet\_spoke1\_id](#input\_subnet\_spoke1\_id)

Description: Subnet id of spoke1 for VMs

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: The admin username for the VM

Type: `string`

Default: `"azureuser"`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

### <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size)

Description: The size of the VM

Type: `string`

Default: `"Standard_B2ms"`

### <a name="input_vm_storage_account_type"></a> [vm\_storage\_account\_type](#input\_vm\_storage\_account\_type)

Description: The storage account type for the VM

Type: `string`

Default: `"Standard_LRS"`

## Outputs

The following outputs are exported:

### <a name="output_spoke1_admin_password"></a> [spoke1\_admin\_password](#output\_spoke1\_admin\_password)

Description: Admin password for spoke1 VM

### <a name="output_spoke1_private_ip"></a> [spoke1\_private\_ip](#output\_spoke1\_private\_ip)

Description: Private IP address of spoke1 VM
<!-- END_TF_DOCS -->