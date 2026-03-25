output "subnet_spoke1_id" {
  value       = azurerm_subnet.spoke1-vm.id
  description = "The ID of the spoke1 subnet for VMs"
}

output "subnet_spoke1_pe_id" {
  value       = azurerm_subnet.spoke1-pe.id
  description = "The ID of the spoke1 subnet for Private Endpoints"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.hub-bastion.id
  description = "The ID of the bastion subnet"
}

output "bastion_subnet_ip_prefixes" {
  value       = azurerm_subnet.hub-bastion.address_prefixes
  description = "The address prefixes of the bastion subnet"
}

output "spoke1_subnet_ip_prefixes" {
  value       = azurerm_subnet.spoke1-vm.address_prefixes
  description = "The address prefixes of the spoke1 subnet for VMs"
}

output "private_dns_zone_postgresql_id" {
  value       = azurerm_private_dns_zone.postgresql.id
  description = "The ID of the private DNS zone for PostgreSQL"
}

output "private_dns_zone_postgresql_name" {
  value       = azurerm_private_dns_zone.postgresql.name
  description = "The name of the private DNS zone for PostgreSQL"
}
