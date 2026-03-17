output "linux_vm_public_ips" {
  description = "Public IP addresses for Linux VMs"
  value = var.image_selection == "ubuntu" ? {
    for vm in azurerm_linux_virtual_machine.vm_linux : vm.name => vm.public_ip_address
  } : null
}

output "windows_vm_public_ips" {
  description = "Public IP addresses for Windows VMs"
  value = var.image_selection == "windows" ? {
    for vm in azurerm_windows_virtual_machine.vm_windows : vm.name => vm.public_ip_address
  } : null
}

output "ssh_commands" {
  description = "Copy-paste commands to access your nodes"
  value = var.image_selection == "ubuntu" ? [
    for vm in azurerm_linux_virtual_machine.vm_linux : "ssh ${var.admin_username}@${vm.public_ip_address}"
  ] : ["Access via RDP for Windows nodes"]
}