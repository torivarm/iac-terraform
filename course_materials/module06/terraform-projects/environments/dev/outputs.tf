output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "plan_id" {
  value = azurerm_service_plan.plan.id
}

output "webapp_id" {
  value = azurerm_linux_web_app.app.id
}

output "webapp_url" {
  value = azurerm_linux_web_app.app.default_hostname
}
