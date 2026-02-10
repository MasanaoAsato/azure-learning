locals {
  allowed_storage_values        = [32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, 33553408]
  postgeresql_possible_versions = ["11", "12", "13", "14", "15", "16", "17", "18"]
}

variable "resource_group_default_location" {
  description = "The location of the resource group default"
  type        = string
}

variable "resource_group_default_name" {
  description = "The name of the resource group default"
  type        = string
}

variable "azure_subnet_postgresql_id" {
  description = "The ID of the subnet for PostgreSQL"
  type        = string
}

variable "private_dns_zone_postgresql_id" {
  description = "The ID of the private DNS zone for PostgreSQL"
  type        = string
}

variable "db_storage" {
  description = "The storage size for the database in MB"
  type        = number
  default     = 32768
  validation {
    condition     = contains(local.allowed_storage_values, var.db_storage)
    error_message = "The db_storage must be one of the following values (in MB): ${join(", ", local.allowed_storage_values)}."
  }
}

variable "db_sku_name" {
  description = "The SKU Name for the PostgreSQL Flexible Server. Examples: B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "db_backup_retention_days" {
  description = "The backup retention days for the database"
  type        = number
  default     = 7

  validation {
    condition     = var.db_backup_retention_days >= 7 && var.db_backup_retention_days <= 35
    error_message = "The backup retention days must be between 7 and 35 days."
  }
}

variable "db_version" {
  description = "The version of the PostgreSQL Flexible Server."
  type        = string
  default     = "18"

  validation {
    condition     = contains(local.postgeresql_possible_versions, var.db_version)
    error_message = "The db_version must be one of the following values: ${join(", ", local.postgeresql_possible_versions)}."
  }
}
