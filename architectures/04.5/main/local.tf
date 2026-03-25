locals {
  # general
  prefix = "test"

  # bastion
  bastion_sku = "Standard"

  # vm
  vm_size                 = "Standard_B2ms"
  vm_storage_account_type = "Standard_LRS"
  admin_username          = "azureuser"

  # database
  db_sku_name = "B_Standard_B1ms"
}
