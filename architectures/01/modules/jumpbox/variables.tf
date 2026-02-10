locals {
  possible_storage_account_types = ["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS ", "Premium_ZRS"]
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "jumpbox_subnet_id" {
  description = "The ID of the jumpbox subnet"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
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
