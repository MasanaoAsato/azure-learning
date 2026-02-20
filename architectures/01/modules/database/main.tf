resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "random" {
  length  = 8
  special = true
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                              = "${var.prefix}-psqlflexibleser-${random_string.random.result}"
  resource_group_name               = var.resource_group_default_name
  location                          = var.resource_group_default_location
  version                           = var.db_version
  zone                              = "2"
  administrator_login               = "pgadmin"
  administrator_password_wo         = random_password.db_password.result
  administrator_password_wo_version = 1
  storage_mb                        = var.db_storage
  sku_name                          = var.db_sku_name
  backup_retention_days             = var.db_backup_retention_days
  public_network_access_enabled     = false
  delegated_subnet_id               = var.azure_subnet_postgresql_id
  private_dns_zone_id               = var.private_dns_zone_postgresql_id
  auto_grow_enabled                 = true
}


resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = "${var.prefix}db"
  server_id = azurerm_postgresql_flexible_server.example.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # prevent the possibility of accidental data loss
  #lifecycle {
  #  prevent_destroy = true
  #}
}
