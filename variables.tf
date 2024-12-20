variable "create_vm" {
  description = "Creates bastion host VM"
  type        = bool
  default     = false
}

variable "create_public_ip" {
  description = "Creates public IP for the bastion host VM"
  type        = bool
  default     = true
}

variable "enable_public_static_ip" {
  description = "Enables `Static` allocation method for the public IP address of Jump Server. Setting false will enable `Dynamic` allocation method."
  type        = bool
  default     = true
}

variable "vm_admin" {
  description = "OS Admin User for Oracle VM"
  type        = string
  default     = "orauser"
}

variable "vm_zone" {
  description = "The Zone in which this Virtual Machine should be created. Changing this forces a new resource to be created"
  type        = string
  default     = "1"
}

variable "vm_machine_type" {
  description = "SKU which should be used for this Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}

variable "db_disk_size" {
  description = "Size of additional LUN's"
  type        = number
  default     = 128
}