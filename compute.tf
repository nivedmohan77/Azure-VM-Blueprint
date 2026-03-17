locals {
  # Logic to handle the user's placement selection
  vm_mapping = [
    for i in range(var.vm_count) : {
      index    = i
      vnet_idx = var.placement_mode == "distribute" ? (i % var.vnet_count) : 0
    }
  ]

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

# The size parameter is updated to use the var.vm_sku (Standard_E2as_v4)
resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.image_selection == "ubuntu" ? var.vm_count : 0
  name                            = "vm-linux-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_sku
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.os_image.ubuntu.publisher
    offer     = local.os_image.ubuntu.offer
    sku       = local.os_image.ubuntu.sku
    version   = local.os_image.ubuntu.version
  }
}

# Repeat similar 'size = var.vm_sku' for azurerm_windows_virtual_machine