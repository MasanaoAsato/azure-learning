# hub のVnetとサブネット
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-network"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "hub-fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_subnet" "hub-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/24"]
}

# spoke1のVnetとサブネット
resource "azurerm_virtual_network" "spoke1" {
  name                = "${var.prefix}-spoke1-network"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  address_space       = ["10.1.0.0/16"]
}


resource "azurerm_subnet" "spoke1-vm" {
  name                 = "${var.prefix}-spoke1-vm-subnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Private Endpoint用サブネット
resource "azurerm_subnet" "spoke1-pe" {
  name                              = "${var.prefix}-spoke1-pe-subnet"
  resource_group_name               = var.resource_group_default_name
  virtual_network_name              = azurerm_virtual_network.spoke1.name
  address_prefixes                  = ["10.1.2.0/24"]
  private_endpoint_network_policies = "Enabled"
}

# vnet peeringの設定（Hub ↔ Spoke1 のみ）
resource "azurerm_virtual_network_peering" "hub-spoke1" {
  name                      = "peer-hub-to-spoke1"
  resource_group_name       = var.resource_group_default_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke1-hub" {
  name                      = "peer-spoke1-to-hub"
  resource_group_name       = var.resource_group_default_name
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}

# HubのVnetのAzure Firewall
resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}firewallpip"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "example" {
  name                = "${var.prefix}firewall"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  firewall_policy_id = azurerm_firewall_policy.example.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub-fw.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_firewall_policy" "example" {
  name                = "example-policy"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
}

resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "spoke-communication"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 100

  # spoke1 VM → Private Endpoint (PostgreSQL) への5432許可
  network_rule_collection {
    name     = "allow-spoke1-to-postgresql"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "allow-postgresql"
      protocols             = ["TCP"]
      source_addresses      = ["10.1.1.0/24"]
      destination_addresses = ["10.1.2.0/24"]
      destination_ports     = ["5432"]
    }
  }

  network_rule_collection {
    name     = "allow-spokes-to-internet-web"
    priority = 110
    action   = "Allow"
    rule {
      name                  = "allow-web-egress"
      protocols             = ["TCP"]
      source_addresses      = ["10.1.1.0/24"]
      destination_addresses = ["0.0.0.0/0"]
      destination_ports     = ["80", "443"]
    }
  }
}

# ルートテーブルの設定
resource "azurerm_route_table" "spoke1" {
  name                          = "${var.prefix}-rt-spoke1-workload"
  location                      = var.resource_group_default_location
  resource_group_name           = var.resource_group_default_name
  bgp_route_propagation_enabled = false

  route {
    name                   = "route-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.example.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke1-vm" {
  subnet_id      = azurerm_subnet.spoke1-vm.id
  route_table_id = azurerm_route_table.spoke1.id
}

# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_default_name
}

# Private DNS Zone を Spoke1 VNet にリンク
resource "azurerm_private_dns_zone_virtual_network_link" "spoke1" {
  name                  = "${var.prefix}-dnslink-spoke1"
  resource_group_name   = var.resource_group_default_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.spoke1.id
  registration_enabled  = false
}
