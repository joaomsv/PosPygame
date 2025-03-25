# 10. Outputs úteis
output "public_ip" {
  description = "IP público da VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "storage_account_name" {
  description = "Nome da Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_container_name" {
  description = "Nome do container de armazenamento"
  value       = azurerm_storage_container.container.name
}
