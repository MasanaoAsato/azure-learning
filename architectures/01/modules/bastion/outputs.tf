output "bastion_id" {
  value       = azurerm_bastion_host.main.id
  description = "The ID of the Azure Bastion"
}

output "bastion_dns_name" {
  value       = azurerm_bastion_host.main.dns_name
  description = "The DNS name of the Azure Bastion"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion.ip_address
  description = "The public IP address of the Azure Bastion"
}
