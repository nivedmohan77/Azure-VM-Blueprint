variable "vm_count" {
  description = "Number of VMs to deploy"
  type        = number
}

variable "vnet_count" {
  description = "Number of Virtual Networks to deploy"
  type        = number
}

variable "distribute_across_vnets" {
  description = "If true, VMs are spread across vNETs. If false, all VMs go into the first vNET."
  type        = bool
  default     = true
}

variable "location" {
  description = "Azure Region selection"
  type        = string
  validation {
    condition     = contains(["centralindia", "eastasia", "australiaeast"], var.location)
    error_message = "Region must be centralindia, eastasia, or australiaeast."
  }
}

variable "image_selection" {
  description = "OS Image selection"
  type        = string
  validation {
    condition     = contains(["ubuntu", "windows"], var.image_selection)
    error_message = "Selection must be 'ubuntu' (24.04 LTS) or 'windows' (Server 2019)."
  }
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