output "private_ip" {
  value = var.create_vm ? module.vm[0].private_ip_address : null
}

output "public_ip" {
  value = var.create_vm && var.create_public_ip ? module.vm[0].public_ip_address : null
}

output "admin_username" {
  value = var.create_vm ? module.vm[0].admin_username : null
}