resource "azurerm_resource_group" "default" {
  name     = "${var.prefix}-learning-rg"
  location = var.location
}
