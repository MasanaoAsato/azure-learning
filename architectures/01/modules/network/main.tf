resource "azurerm_virtual_network" "default" {
  name                = "test-vnet"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "postgresql" {
  name                 = "test-postgresql-subnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
    }
  }
}

resource "azurerm_private_dns_zone" "postgresql" {
  name                = "example.postgres.database.azure.com"
  resource_group_name = var.resource_group_default_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "postgres-dns-link"
  resource_group_name   = var.resource_group_default_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.default.id
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "jumpbox-subnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.3.0/24"]
}
