# Azure Provider - Used to communicate with Azure RM
# https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

provider "azurerm" {
  # recommend pinning to a given version of the Provider
  version = "=2.24.0"
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}