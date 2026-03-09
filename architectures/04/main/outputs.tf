output "spoke1_private_ip" {
  value       = module.vm.spoke1_private_ip
  description = "Private IP address of spoke1 VM"
}

output "spoke2_private_ip" {
  value       = module.vm.spoke2_private_ip
  description = "Private IP address of spoke2 VM"
}

output "db_app_username" {
  value       = module.vm.db_app_username
  description = "MySQL application username"
}

output "db_app_password" {
  value       = module.vm.db_app_password
  description = "MySQL application password"
  sensitive   = true
}
