resource "azurerm_network_interface" "main" {
  name                = "vnetnic"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = tolist([
      for s in azurerm_virtual_network.vnet1.subnet : s.id
      if s.name == "subnet1"
    ])[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "vmpeer1"
  location              = data.azurerm_resource_group.rg_vnet.location
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1ls"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


resource "azurerm_network_interface" "main2" {
  name                = "vnetnic2"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = tolist([
      for s in azurerm_virtual_network.vnet2.subnet : s.id
      if s.name == "subnet2"
    ])[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "vmpeer2"
  location              = data.azurerm_resource_group.rg_vnet.location
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  network_interface_ids = [azurerm_network_interface.main2.id]
  vm_size               = "Standard_B1ls"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
 delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "dev"
  }
}
