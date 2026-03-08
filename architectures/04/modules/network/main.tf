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

# spoke2のVnetとサブネット
resource "azurerm_virtual_network" "spoke2" {
  name                = "${var.prefix}-spoke2-network"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "spoke2-vm" {
  name                 = "${var.prefix}-spoke2-vm-subnet"
  resource_group_name  = var.resource_group_default_name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.2.1.0/24"]
}

# spoke1とspoke2のnic
resource "azurerm_network_interface" "spoke1-vm" {
  name                = "${var.prefix}-spoke1-vm-nic"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "spoke2-vm" {
  name                = "${var.prefix}-spoke2-vm-nic"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

# vnet peeringの設定
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
}

resource "azurerm_virtual_network_peering" "hub-spoke2" {
  name                      = "peer-hub-to-spoke2"
  resource_group_name       = var.resource_group_default_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke2-hub" {
  name                      = "peer-spoke2-to-hub"
  resource_group_name       = var.resource_group_default_name
  virtual_network_name      = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
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

  network_rule_collection {
    name     = "allow-spoke1-to-spoke2"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "allow-mysql"
      protocols             = ["TCP"]
      source_addresses      = ["10.1.1.0/24"]
      destination_addresses = ["10.2.1.0/24"]
      destination_ports     = ["3306"]
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

resource "azurerm_route_table" "spoke2" {
  name                          = "${var.prefix}-rt-spoke2-workload"
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

resource "azurerm_subnet_route_table_association" "spoke2-vm" {
  subnet_id      = azurerm_subnet.spoke2-vm.id
  route_table_id = azurerm_route_table.spoke2.id
}
