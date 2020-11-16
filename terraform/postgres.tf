resource "azurerm_postgresql_server" "pgserver" {
  name                = "django-terraform-db"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "postgres"
  administrator_login_password = "thisSuperSECUREPassword2020!"

  sku_name   = "B_Gen5_2"
  version    = "11"
  storage_mb = 51200

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = false
}

resource "azurerm_postgresql_database" "pgdb" {
  name                = "TodoDB"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.pgserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}