output "instance_ip_addr" {
  value       = azurerm_linux_virtual_machine.server.public_ip_address 
  description = "The public IP address of the main server instance."
}

output "instance_admin" {
  value       = azurerm_linux_virtual_machine.server.admin_username
  description = "The admin provisioned with SSH key access."
}


