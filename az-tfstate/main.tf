resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}-rg"
  location = local.location
}

locals {
  resource_group_name = "terraform"
  location            = "Norway East"
}
