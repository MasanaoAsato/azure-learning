resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Jumpbox用NSG
resource "azurerm_network_security_group" "jumpbox" {
  name                = "${var.prefix}-jumpbox-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: Bastion サブネットからの RDP のみ許可
  security_rule {
    name                       = "AllowRDPFromBastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  # Inbound: Bastion サブネットからの SSH も許可
  security_rule {
    name                       = "AllowSSHFromBastion"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  # Inbound: その他をすべて拒否
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound: PostgreSQLへの接続
  security_rule {
    name                       = "AllowPostgreSQLOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  # Outbound: Storage PEサブネットへのHTTPS（Jumpboxからファイルアップロード用）
  security_rule {
    name                       = "AllowStoragePEOutbound"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.5.0/24"
  }

  # Outbound: パッケージ更新用HTTPS
  security_rule {
    name                       = "AllowHttpsOutbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  # Outbound: HTTP (パッケージ更新用)
  security_rule {
    name                       = "AllowHttpOutbound"
    priority                   = 115
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  # Outbound: DNS
  security_rule {
    name                       = "AllowDNSOutbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound: その他をすべて拒否
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSGをJumpboxサブネットに関連付け
resource "azurerm_subnet_network_security_group_association" "jumpbox" {
  subnet_id                 = var.jumpbox_subnet_id
  network_security_group_id = azurerm_network_security_group.jumpbox.id
}


# Jumpbox用NIC
resource "azurerm_network_interface" "jumpbox" {
  name                = "${var.prefix}-jumpbox-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# SSH鍵生成 (linux VMの場合)
# resource "tls_private_key" "jumpbox" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# Jumpbox Linux VM
# resource "azurerm_linux_virtual_machine" "jumpbox" {
#   name                = "${var.prefix}-jumpbox"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   size                = var.vm_size
#   admin_username      = var.admin_username

#   network_interface_ids = [
#     azurerm_network_interface.jumpbox.id,
#   ]

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = tls_private_key.jumpbox.public_key_openssh
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   custom_data = base64encode(<<-EOF
#     #!/bin/bash
#     apt-get update
#     apt-get install -y postgresql-client
#     EOF
#   )

#   tags = {
#     purpose = "jumpbox"
#   }
# }


# Jumpbox Windows VM
resource "azurerm_windows_virtual_machine" "jumpbox" {
  name                = "${var.prefix}-jumpbox"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.admin_password.result
  patch_mode          = "AutomaticByPlatform" # 2025-datacenter-azure-editionでは必須
  timezone            = "Tokyo Standard Time"

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }

  tags = {
    purpose = "jumpbox"
  }
}

# =============================================================================
# VM Extension: インターネットアクセスが必要なため無効化
# Bastion 経由で RDP 接続後、必要なツールを手動インストールしてください:
# - Azure Storage Explorer: https://azure.microsoft.com/features/storage-explorer/
# - pgAdmin: https://www.pgadmin.org/download/pgadmin-4-windows/
# =============================================================================
# resource "azurerm_virtual_machine_extension" "default" {
#   name                       = "tool-setup"
#   virtual_machine_id         = azurerm_windows_virtual_machine.jumpbox.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.10"
#
#   protected_settings = jsonencode({
#     commandToExecute = "powershell -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); choco install microsoftazurestorageexplorer pgadmin4 -y\""
#   })
# }
