resource "azurerm_resource_group" "default" {
  name     = "test-learning-rg"
  location = "Japan East"
  tags = {
    "type" = "test"
  }
}
