variable "prefix" {
  description = "prefix for resource name"
  type        = string

  default = "test"
}

variable "resource_group_default_location" {
  description = "The location of the resource group default"
  type        = string
}

variable "resource_group_default_name" {
  description = "The name of the resource group default"
  type        = string
}
