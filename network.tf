resource "azurerm_resource_group" "main" {
  name     = "rg-k8s-labs"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.vnet_count
  name                = "vnet-${count.index}"
  address_space       = [cidrsubnet("192.168.0.0/16", 8, count.index)]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  count                = var.vnet_count
  name                 = "snet-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet[count.index].name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet[count.index].address_space[0], 4, 0)]
}