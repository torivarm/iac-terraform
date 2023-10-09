data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "${var.kv_name}${var.base_name}${random_string.random_string.result}"
  location                    = azurerm_resource_group.rg-infra.location
  resource_group_name         = azurerm_resource_group.rg-infra.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Delete", "Purge"
    ]

    secret_permissions = [
      "Get", "Set", "List", "Delete"
    ]

    storage_permissions = [
      "Get", "Set", "List", "Delete"
    ]
  }
}

data "azurerm_user" "my_admin_user" {
  user_principal_name = "tor.i.melling_ntnu.no#EXT#@tenant01ntnu.onmicrosoft.com"
}
resource "azurerm_key_vault_access_policy" "adminuser_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_user.my_admin_user.object_id


  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]
  secret_permissions = [
    "Get", "Set", "List", "Delete"
  ]

  storage_permissions = [
    "Get", "Set", "List", "Delete"
  ]
}

resource "azurerm_key_vault_secret" "sa_accesskey" {
  name         = "${var.sa_accesskey_name}${azurerm_storage_account.sa.name}"
  value        = azurerm_storage_account.sa.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_storage_account.sa
  ]
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "${var.vm_name}${random_string.random_string.result}"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    random_password.password
  ]
}