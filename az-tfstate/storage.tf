# Storage Account
resource "azurerm_storage_account" "terraform" {
  name                     = "akisan${local.resource_group_name}sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Account Container
resource "azurerm_storage_container" "example" {
  name                  = "${local.resource_group_name}-state"
  storage_account_id    = azurerm_storage_account.terraform.id
  container_access_type = "private"
}