resource "azurerm_app_service_plan" "asp" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "django-demo-app-tf-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
      linux_fx_version = "DOCKER|tpeterson66/django-todo"
  }

  app_settings = {
      "POSTGRES_HOST" = "${azurerm_postgresql_server.pgserver.fqdn}"
      "POSTGRES_NAME" = "TodoDB"
      "POSTGRES_PASSWORD" = var.db_password
      "POSTGRES_PORT" = "5432"
      "POSTGRES_USER" = "postgres@django-terraform-db.database.azure.com"
  }
}