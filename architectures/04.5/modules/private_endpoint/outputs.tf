output "private_endpoint_ip" {
  value       = azurerm_private_endpoint.postgresql.private_service_connection[0].private_ip_address
  description = "The private IP address of the PostgreSQL Private Endpoint"
}
