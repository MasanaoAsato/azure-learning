resource "random_string" "name" {
  length  = 8
  special = false
}

resource "azurerm_container_registry" "default" {
  name                          = "${var.prefix}acr${random_string.name.result}"
  location                      = var.resource_group_default_location
  resource_group_name           = var.resource_group_default_name
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = true
  georeplications {
    location                = "japanwest"
    zone_redundancy_enabled = false
  }
}
