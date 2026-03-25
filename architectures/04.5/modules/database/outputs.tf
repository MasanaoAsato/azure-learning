output "postgresql_server_id" {
  value       = azurerm_postgresql_flexible_server.example.id
  description = "The ID of the PostgreSQL Flexible Server"
}

output "postgresql_server_fqdn" {
  value       = azurerm_postgresql_flexible_server.example.fqdn
  description = "The FQDN of the PostgreSQL Flexible Server"
}

output "db_admin_password" {
  value       = random_password.db_password.result
  description = "The admin password for the PostgreSQL Flexible Server"
  sensitive   = true
}
