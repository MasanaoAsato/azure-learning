output "spoke1_private_ip" {
  value       = azurerm_linux_virtual_machine.spoke1.private_ip_address
  description = "Private IP address of spoke1 VM"
}

output "spoke1_admin_password" {
  value       = random_password.admin_password_spoke1.result
  description = "Admin password for spoke1 VM"
  sensitive   = true
}
