output "vnet_id" {
  value       = azurerm_virtual_network.default.id
  description = "The ID of the virtual network"
}

output "azure_subnet_postgresql_id" {
  value       = azurerm_subnet.postgresql.id
  description = "The ID of the PostgreSQL subnet"
}

output "private_dns_zone_postgresql_id" {
  value       = azurerm_private_dns_zone.postgresql.id
  description = "The ID of the PostgreSQL private DNS zone"
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.default.name
  description = "The name of the virtual network"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion.id
  description = "The ID of the Bastion subnet"
}

output "jumpbox_subnet_id" {
  value       = azurerm_subnet.jumpbox.id
  description = "The ID of the jumpbox subnet"
}
