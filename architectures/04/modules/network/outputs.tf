output "subnet_spoke1_id" {
  value       = azurerm_subnet.spoke1-vm.id
  description = "The ID of the spoke1 subnet for VMs"
}

output "subnet_spoke2_id" {
  value       = azurerm_subnet.spoke2-vm.id
  description = "The ID of the spoke2 subnet for VMs"
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
