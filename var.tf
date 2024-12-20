variable "client_id" {
  description = "The Client ID for the Service Principal"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "The Client Secret for the Service Principal."
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "The ID of the Subscription."
  type        = string
}

variable "tenant_id" {
  description = "The ID of the Tenant to which the subscription belongs"
  type        = string
}

variable "use_msi" {
  description = "Use Managed Identity for Authentication (Azure VMs only)"
  type        = bool
  default     = false
}

variable "date" {
 type = string
}

variable "prefix" {
  type = string
}

variable "resource_group" {
  type = string
}     

variable "resource_group_location" {
  type    = string
  default = "eastus"
}

variable "virtual_machine_size" {
  type    = string
  default = "Standard_B2s"
}

variable "virtual_machine_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "virtual_machine_disk_size" {
  type    = number
  default = 512
}

variable "virtual_machine_userid" {
  type    = string
  default = "meraxes"
}

variable "rules" {
  type    = list(map(string))
  default = [
    {
      name                         = "Azure_Cloud"
      priority                     = "100"
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_address_prefix        = "AzureCloud"
      source_port_range            = "*"
      destination_address_prefix   = "*"
      destination_port_range       = "*"
      description                  = "Allow Azure Cloud Serivces"
    }
  ]
}

variable "tags" {
  description = "Map of common tags to be placed on the Resources"
  type        = map(any)
  default     = {}
}

variable "ssh_public_key" {
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "public_access_cidrs" {
  description = "Default list of CIDRs to access created resources."
  type        = list(string)
  default     = null
}

#variable "ssh_public_key" {
#  description = "Public Key for Server Access"
#  type        = string
#}
