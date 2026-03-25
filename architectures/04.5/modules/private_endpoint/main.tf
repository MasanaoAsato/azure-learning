# PostgreSQL Flexible Server 向けの Private Endpoint
resource "azurerm_private_endpoint" "postgresql" {
  name                = "${var.prefix}-pe-postgresql"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.prefix}-psc-postgresql"
    private_connection_resource_id = var.postgresql_server_id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  # DNS Zone Group: PE作成時にPrivate DNS Zoneへ自動でAレコードを登録する
  private_dns_zone_group {
    name                 = "postgresql-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_postgresql_id]
  }
}
