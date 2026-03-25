resource "random_password" "admin_password_spoke1" {
  length      = 16
  special     = false
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "azurerm_network_security_group" "spoke1" {
  name                = "${var.prefix}-nsg-spoke1"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  # Inbound: Bastion からの SSH 許可
  security_rule {
    name                       = "AllowSSHFromBastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.bastion_subnet_ip_prefixes[0]
    destination_address_prefix = "*"
  }
  # Inbound: それ以外は拒否
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSGをspoke1サブネットに関連付け
resource "azurerm_subnet_network_security_group_association" "spoke1" {
  subnet_id                 = var.subnet_spoke1_id
  network_security_group_id = azurerm_network_security_group.spoke1.id
}

resource "azurerm_network_interface" "spoke1-vm" {
  name                = "${var.prefix}-spoke1-vm-nic"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_spoke1_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ここでは、簡単のためにssh_keyではなく、admin_passwordにします。
resource "azurerm_linux_virtual_machine" "spoke1" {
  name                            = "${var.prefix}-spoke1-vm"
  location                        = var.resource_group_default_location
  resource_group_name             = var.resource_group_default_name
  network_interface_ids           = [azurerm_network_interface.spoke1-vm.id]
  admin_username                  = var.admin_username
  admin_password                  = random_password.admin_password_spoke1.result
  disable_password_authentication = false
  size                            = var.vm_size

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # PostgreSQL クライアントをインストール（PE経由の接続確認用）
  custom_data = base64encode(<<-EOF
    #cloud-config
    package_update: true
    packages:
      - postgresql-client
  EOF
  )
}
