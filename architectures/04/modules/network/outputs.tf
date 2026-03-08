output "subnet_spoke1_id" {
  value       = azurerm_subnet.spoke1-vm.id
  description = "The ID of the spoke1 subnet for VMs"
}

output "subnet_spoke2_id" {
  value       = azurerm_subnet.spoke2-vm.id
  description = "The ID of the spoke2 subnet for VMs"
}
