
resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "mssql" {
  name                         = var.mssql_name
  resource_group_name          = var.rgname
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "mssqldb" {
  name           = var.mssqldb_name
  server_id      = azurerm_mssql_server.mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0" # Adjust the SKU according to the needed tier and performance level
  max_size_gb    = 2    # Adjust the maximum size to a supported value for the selected SKU
  zone_redundant = false

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}