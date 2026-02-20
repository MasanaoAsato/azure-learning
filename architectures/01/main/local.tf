locals {
  # common
  prefix = "test"

  # database関連
  db_storage               = 32768
  db_sku_name              = "GP_Standard_D2s_v3"
  db_backup_retention_days = 7
  db_version               = "18"

  #bastion関連
  bastion_sku = "Standard"

  # jumpbox関連
  vm_size                 = "Standard_B2ms"
  admin_username          = "azureuser"
  vm_storage_account_type = "Standard_LRS"
}
