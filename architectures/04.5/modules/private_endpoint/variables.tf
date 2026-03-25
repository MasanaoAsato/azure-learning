variable "resource_group_default_location" {
  description = "The location of the resource group default"
  type        = string
}

variable "resource_group_default_name" {
  description = "The name of the resource group default"
  type        = string
}

variable "prefix" {
  description = "prefix for resource name"
  type        = string

  default = "test"
}

variable "pe_subnet_id" {
  description = "The ID of the subnet for Private Endpoints"
  type        = string
}

variable "postgresql_server_id" {
  description = "The ID of the PostgreSQL Flexible Server to connect via Private Endpoint"
  type        = string
}

variable "private_dns_zone_postgresql_id" {
  description = "The ID of the private DNS zone for PostgreSQL"
  type        = string
}
