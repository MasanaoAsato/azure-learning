output "subnet_spoke1_id" {
  value       = azurerm_subnet.spoke1-vm.id
  description = "The ID of the spoke1 subnet for VMs"
}

output "subnet_spoke2_id" {
  value       = azurerm_subnet.spoke2-vm.id
  description = "The ID of the spoke2 subnet for VMs"
}

output "nic_spoke1_id" {
  value       = azurerm_network_interface.spoke1-vm.id
  description = "The ID of the spoke1 VM network interface"
}

output "nic_spoke2_id" {
  value       = azurerm_network_interface.spoke2-vm.id
  description = "The ID of the spoke2 VM network interface"
}
