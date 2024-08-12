locals {
  workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  rg_name = "${var.rg_name}-${local.workspaces_suffix}"
}


resource "azurerm_resource_group" "rg" {
    name     = local.rg_name
    location = var.rg_location
}

output "rg_name" {
    value = azurerm_resource_group.rg.name
}