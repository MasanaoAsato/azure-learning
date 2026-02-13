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

- [azurerm_postgresql_flexible_server.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) (resource)
- [azurerm_postgresql_flexible_server_database.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) (resource)
- [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_azure_subnet_postgresql_id"></a> [azure\_subnet\_postgresql\_id](#input\_azure\_subnet\_postgresql\_id)

Description: The ID of the subnet for PostgreSQL

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

### <a name="input_db_backup_retention_days"></a> [db\_backup\_retention\_days](#input\_db\_backup\_retention\_days)

Description: The backup retention days for the database

Type: `number`

Default: `7`

### <a name="input_db_sku_name"></a> [db\_sku\_name](#input\_db\_sku\_name)

Description: The SKU Name for the PostgreSQL Flexible Server. Examples: B\_Standard\_B1ms, GP\_Standard\_D2s\_v3, MO\_Standard\_E4s\_v3

Type: `string`

Default: `"GP_Standard_D2s_v3"`

### <a name="input_db_storage"></a> [db\_storage](#input\_db\_storage)

Description: The storage size for the database in MB

Type: `number`

Default: `32768`

### <a name="input_db_version"></a> [db\_version](#input\_db\_version)

Description: The version of the PostgreSQL Flexible Server.

Type: `string`

Default: `"18"`

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: prefix for resource name

Type: `string`

Default: `"test"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->