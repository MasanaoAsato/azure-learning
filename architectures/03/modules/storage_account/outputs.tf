output "primary_web_host" {
  value       = azurerm_storage_account.static_website.primary_web_host
  description = "The hostname of the static website"
}
