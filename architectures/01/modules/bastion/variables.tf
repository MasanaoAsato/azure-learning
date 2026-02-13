locals {
  possible_bastion_sku = ["Developer", "Basic", "Standard", "Premium"]
}

variable "prefix" {
  description = "prefix for resource name"
  type        = string

  default = "test"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "bastion_subnet_id" {
  description = "The ID of the Bastion subnet"
  type        = string
}

variable "bastion_sku" {
  description = "The SKU of the Azure Bastion Host"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(local.possible_bastion_sku, var.bastion_sku)
    error_message = "The bastion_sku must be one of the following values: ${join(", ", local.possible_bastion_sku)}."
  }
}
