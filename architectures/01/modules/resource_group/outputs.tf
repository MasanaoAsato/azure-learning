output "resource_group_default_location" {
  value       = azurerm_resource_group.default.location
  description = "The location of the resource group default"
}

output "resource_group_default_name" {
  value       = azurerm_resource_group.default.name
  description = "The name of the resource group default"
}
