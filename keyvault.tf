# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = "${local.resource_group_name}-kv"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  # purge_protection_enabled    = false
  # enabled_for_disk_encryption = true

  sku_name = var.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions    = var.key_permissions
    secret_permissions = var.secret_permissions
  }
}

# Generate Password for Key Vault Secret
resource "random_password" "password" {
  length           = 20
  special          = true
  override_special = "%&*()-_=+[]{}<>:?"
}

# Key Vault Entry
resource "azurerm_key_vault_secret" "key" {
  name         = "akisan-db-password"
  key_vault_id = azurerm_key_vault.kv.id
  value        = random_password.password.result
}
