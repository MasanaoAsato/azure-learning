# Generate random value for the storage account name
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "static_website" {
  resource_group_name = var.resource_group_default_name
  location            = var.resource_group_default_location

  name = "${var.prefix}${random_string.storage_account_name.result}"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true
  sftp_enabled                      = false
  local_user_enabled                = false
  default_to_oauth_authentication   = true
  public_network_access_enabled     = true
  https_traffic_only_enabled        = true
}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.static_website.id
  error_404_document = "not_found.html"
  index_document     = "index.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.static_website.name
  storage_container_name = "$web" # azure_storage_account_static_website creates a container named $web for hosting the static website
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.module}/index.html"

  depends_on = [azurerm_storage_account_static_website.static_website]
}

resource "azurerm_storage_blob" "not_found" {
  name                   = "not_found.html"
  storage_account_name   = azurerm_storage_account.static_website.name
  storage_container_name = "$web" # azure_storage_account_static_website creates a container named $web for hosting the static website
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.module}/not_found.html"

  depends_on = [azurerm_storage_account_static_website.static_website]
}
