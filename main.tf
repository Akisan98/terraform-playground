resource "azurerm_resource_group" "rg" {
  name     = "${random_pet.name.id}-${var.resource_group_name_postfix}"
  location = var.resource_group_location
}

resource "random_pet" "name" {
  length = 1
}