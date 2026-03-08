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
  name                  = "${var.prefix}-spoke1-vm"
  location              = var.resource_group_default_location
  resource_group_name   = var.resource_group_default_name
  network_interface_ids = [azurerm_network_interface.spoke1-vm.id]
  admin_username        = var.admin_username
  admin_password        = random_password.admin_password_spoke1.result
  disable_password_authentication = false
  size                  = var.vm_size

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
  name                  = "${var.prefix}-spoke2-vm"
  location              = var.resource_group_default_location
  resource_group_name   = var.resource_group_default_name
  network_interface_ids = [azurerm_network_interface.spoke2-vm.id]
  admin_username        = var.admin_username
  admin_password        = random_password.admin_password_spoke2.result
  disable_password_authentication = false
  size                  = var.vm_size

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
      - systemctl enable mysql
      - systemctl start mysql
  EOF
  )
}
