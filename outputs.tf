################################################################################
# OUTPUTS
# These values are printed to the console after a successful terraform apply.
################################################################################

# Output for Linux VM IPs (Only shows if Ubuntu was selected)
output "linux_vm_public_ips" {
  description = "The Public IP addresses assigned to the Linux VMs."
  value = var.image_selection == "ubuntu" ? {
    for vm in azurerm_linux_virtual_machine.vm_linux : 
    vm.name => vm.public_ip_address
  } : null
}

# Output for Windows VM IPs (Only shows if Windows was selected)
output "windows_vm_public_ips" {
  description = "The Public IP addresses assigned to the Windows VMs."
  value = var.image_selection == "windows" ? {
    for vm in azurerm_windows_virtual_machine.vm_windows : 
    vm.name => vm.public_ip_address
  } : null
}

# General output for easy copy-pasting for Kubeadm SSH access
output "ssh_connection_commands" {
  description = "Helper commands to SSH into your new nodes."
  value = var.image_selection == "ubuntu" ? [
    for vm in azurerm_linux_virtual_machine.vm_linux : 
    "ssh ${var.admin_username}@${vm.public_ip_address}"
  ] : ["Windows VMs deployed - use RDP to access."]
}