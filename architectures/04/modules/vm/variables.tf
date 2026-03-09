locals {
  possible_storage_account_types = ["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS ", "Premium_ZRS"]
}

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

variable "subnet_spoke1_id" {
  description = "Subnet id of spoke1 for VMs"
  type        = string
}

variable "subnet_spoke2_id" {
  description = "Subnet id of spoke2 for VMs"
  type        = string
}

variable "bastion_subnet_ip_prefixes" {
  description = "The address prefixes of the bastion subnet"
  type        = list(string)
}

variable "spoke1_subnet_ip_prefixes" {
  description = "The address prefixes of the spoke1 subnet for VMs"
  type        = list(string)
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "vm_storage_account_type" {
  description = "The storage account type for the VM"
  type        = string
  default     = "Standard_LRS"

  validation {
    condition     = contains(local.possible_storage_account_types, var.vm_storage_account_type)
    error_message = "The vm_storage_account_type must be one of the following values: ${join(", ", local.possible_storage_account_types)}."
  }
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "db_app_username" {
  description = "Application username for MySQL on spoke2"
  type        = string
  default     = "appuser"
}
