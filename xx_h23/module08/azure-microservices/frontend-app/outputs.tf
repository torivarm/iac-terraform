output "app_service_url" {
  value = azurerm_linux_function_app.funcapp.default_hostname
}
