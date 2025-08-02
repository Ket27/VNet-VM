data "azurerm_resource_group" "rg_vnet" {
  name = "Vnet-Peering"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "net-security-group"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnetpeer1"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet1"
    address_prefix = "10.0.0.0/24"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnetpeer2"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet2"
    address_prefix = "10.1.0.0/24"
  }

  tags = {
    environment = "Deployment"
  }
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer1to2"
  resource_group_name       = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer2to1"
  resource_group_name       = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}
