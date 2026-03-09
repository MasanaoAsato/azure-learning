output "spoke1_private_ip" {
  value       = azurerm_linux_virtual_machine.spoke1.private_ip_address
  description = "Private IP address of spoke1 VM"
}

output "spoke2_private_ip" {
  value       = azurerm_linux_virtual_machine.spoke2.private_ip_address
  description = "Private IP address of spoke2 VM"
}

output "db_app_username" {
  value       = var.db_app_username
  description = "MySQL application username"
}

output "db_app_password" {
  value       = random_password.db_app_password.result
  description = "MySQL application password"
  sensitive   = true
}
