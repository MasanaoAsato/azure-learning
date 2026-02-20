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

- [azurerm_network_interface.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_network_security_group.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_subnet_network_security_group_association.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_windows_virtual_machine.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) (resource)
- [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_jumpbox_subnet_id"></a> [jumpbox\_subnet\_id](#input\_jumpbox\_subnet\_id)

Description: The ID of the jumpbox subnet

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group

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

No outputs.
<!-- END_TF_DOCS -->