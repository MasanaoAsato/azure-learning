# NSG の設定は今回のスコープ外にする。

resource "random_password" "admin_password_spoke1" {
  length      = 16
  special     = false
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "random_password" "admin_password_spoke2" {
  length      = 16
  special     = false
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "random_password" "db_app_password" {
  length      = 20
  special     = false
  min_lower   = 6
  min_upper   = 6
  min_numeric = 6
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

resource "azurerm_network_security_group" "spoke2" {
  name                = "${var.prefix}-nsg-spoke2"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name
  # Inbound: Bastion からの SSH 許可 (管理用)
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
  # Inbound: Spoke1 からの MySQL 接続許可
  security_rule {
    name                       = "AllowMySQLFromSpoke1"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = var.spoke1_subnet_ip_prefixes[0]
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

# NSGをJumpboxサブネットに関連付け
resource "azurerm_subnet_network_security_group_association" "spoke1" {
  subnet_id                 = var.subnet_spoke1_id
  network_security_group_id = azurerm_network_security_group.spoke1.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2" {
  subnet_id                 = var.subnet_spoke2_id
  network_security_group_id = azurerm_network_security_group.spoke2.id
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

  custom_data = base64encode(<<-EOF
    #cloud-config
    package_update: true
    packages:
      - mysql-client
  EOF
  )
}

resource "azurerm_network_interface" "spoke2-vm" {
  name                = "${var.prefix}-spoke2-vm-nic"
  location            = var.resource_group_default_location
  resource_group_name = var.resource_group_default_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_spoke2_id
    private_ip_address_allocation = "Dynamic"
  }
}


# ここでは、簡単のためにssh_keyではなく、admin_passwordにします。
resource "azurerm_linux_virtual_machine" "spoke2" {
  name                            = "${var.prefix}-spoke2-vm"
  location                        = var.resource_group_default_location
  resource_group_name             = var.resource_group_default_name
  network_interface_ids           = [azurerm_network_interface.spoke2-vm.id]
  admin_username                  = var.admin_username
  admin_password                  = random_password.admin_password_spoke2.result
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

  custom_data = base64encode(<<-EOF
    #cloud-config
    package_update: true
    packages:
      - mysql-server
    runcmd:
      - until apt-get update; do sleep 10; done
      - until DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server; do sleep 10; done
      - test -f /etc/mysql/mysql.conf.d/mysqld.cnf && sed -ri 's/^[[:space:]]*bind-address[[:space:]]*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
      - test -f /etc/mysql/mysql.conf.d/mysqld.cnf && sed -ri 's/^[[:space:]]*skip-networking/# skip-networking/' /etc/mysql/mysql.conf.d/mysqld.cnf
      - systemctl enable mysql
      - systemctl start mysql
      - systemctl restart mysql
      - mysql -e "CREATE USER IF NOT EXISTS '${var.db_app_username}'@'${join(".", slice(split(".", split("/", var.spoke1_subnet_ip_prefixes[0])[0]), 0, 3))}.%' IDENTIFIED BY '${random_password.db_app_password.result}';"
      - mysql -e "CREATE DATABASE IF NOT EXISTS appdb;"
      - mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO '${var.db_app_username}'@'${join(".", slice(split(".", split("/", var.spoke1_subnet_ip_prefixes[0])[0]), 0, 3))}.%';"
      - mysql -e "FLUSH PRIVILEGES;"
  EOF
  )
}
