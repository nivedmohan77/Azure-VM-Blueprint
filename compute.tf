locals {
  # Logic to determine which subnet each VM belongs to
  vm_mapping = [
    for i in range(var.vm_count) : {
      index    = i
      vnet_idx = var.distribute_across_vnets ? (i % var.vnet_count) : 0
    }
  ]

  # Image mapping
  os_image = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }
    windows = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
  }
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "pip-vm-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-vm-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal[local.vm_mapping[count.index].vnet_idx].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

# Linux VM deployment
resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.image_selection == "ubuntu" ? var.vm_count : 0
  name                            = "vm-linux-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Standard HDD
  }

  source_image_reference {
    publisher = local.os_image.ubuntu.publisher
    offer     = local.os_image.ubuntu.offer
    sku       = local.os_image.ubuntu.sku
    version   = local.os_image.ubuntu.version
  }
}

# Windows VM deployment
resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                 = var.image_selection == "windows" ? var.vm_count : 0
  name                  = "vm-win-${count.index}"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.os_image.windows.publisher
    offer     = local.os_image.windows.offer
    sku       = local.os_image.windows.sku
    version   = local.os_image.windows.version
  }
}

output "vm_public_ips" {
  value = {
    for i in range(var.vm_count) : 
    "vm-${i}" => azurerm_public_ip.pip[i].ip_address
  }
}