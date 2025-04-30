resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}-rg"
  location = var.resource_group_location
}