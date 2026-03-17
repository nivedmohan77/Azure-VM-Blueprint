variable "vm_count" {
  description = "Enter the number of VMs to be deployed:"
  type        = number
}

variable "vnet_count" {
  description = "Enter the number of vNETs to be deployed:"
  type        = number
}

variable "placement_mode" {
  description = "Placement Mode: Enter 'distribute' to spread VMs across all vNETs equally, or 'single' to deploy all inside the same (first) vNET:"
  type        = string
  validation {
    condition     = contains(["distribute", "single"], var.placement_mode)
    error_message = "Please enter either 'distribute' or 'single'."
  }
}

variable "location" {
  description = "Azure Region selection (Options: centralindia, eastasia, australiaeast):"
  type        = string
  validation {
    condition     = contains(["centralindia", "eastasia", "australiaeast"], var.location)
    error_message = "Invalid region. Choose from: centralindia, eastasia, australiaeast."
  }
}

variable "image_selection" {
  description = "Image selection (Options: ubuntu, windows):"
  type        = string
  validation {
    condition     = contains(["ubuntu", "windows"], var.image_selection)
    error_message = "Invalid image. Choose 'ubuntu' (24.04 LTS) or 'windows' (Server 2019)."
  }
}

variable "vm_sku" {
  description = "VM Size"
  type        = string
  default     = "Standard_E2as_v4"
}

variable "admin_username" {
  type    = string
  default = "userx"
}

variable "admin_password" {
  type      = string
  default   = "7907077905Nm"
  sensitive = true
}