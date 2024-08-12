output "app_service_url" {
  value = azurerm_linux_function_app.funcapp.default_hostname
}

output "app_insight_instrumentation_key" {
  value     = azurerm_application_insights.ai-funcapp.instrumentation_key
  sensitive = true
}