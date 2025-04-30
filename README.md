# Terraform Configuration Files

This directory contains the Terraform configuration files necessary for managing infrastructure.

## Prerequisites
- Ensure you have Terraform installed on your machine. You can download it from the [Terraform website](https://www.terraform.io/downloads.html).
- Ensure you have the Azure CLI installed and configured. You can download it from the [Azure CLI installation guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Ensure you have an active Azure subscription. You can create a free account [here](https://azure.microsoft.com/en-us/free/).

### Authentication
- Ensure you are authenticated with Azure. You can do this by running the following command in your terminal:
```bash
az login
```
- Ensure you have the necessary permissions to create and manage resources in the specified Azure subscription.

## Files

- `main.tf`: The main configuration file.
- `provider.tf`: The provider configuration file. Similar to "package.json" in Node.js, this file specifies the provider and its version.

### azurerm >= 4.0.0 
- The `azurerm` provider version 4.0.0 and above requires the subscription ID to be specified in the provider block.
To avoid hardcoding the subscription ID, we will set the `ARM_SUBSCRIPTION_ID` environment variable.
Linux and MacOS:
```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

Windows:
```cmd
set ARM_SUBSCRIPTION_ID="your-subscription-id"
```

- Alternatively, you can specify the subscription ID directly in the `provider.tf` file:
```hcl
provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"
}
```

## Let's get started!

1. **Initialize Terraform**: Run the following command to initialize the Terraform configuration, the upgrade flag is optional, it will upgrade the providers to the latest version:
```bash
terraform init -upgrade
```
2. **Plan the Infrastructure**: Run the following command to see what changes Terraform will make to your infrastructure, the `-out` flag is optional, but highly recommended, it will save the plan to a file:
```bash
terraform plan -out main.tfplan
```
3. **Apply the Configuration**: Run the following command to apply the configuration and create the resources:
```bash
terraform apply main.tfplan
```
4. **Destroy the Infrastructure**: When you are done, you can destroy the resources created by Terraform by running:
```bash
terraform destroy
```

Now that we have successfully created and deleted a resource group, we have an how Terraform or Infrastructure as code can help us manage infrastructure. Now let's expand on this.

Although our example is simple, we are still hard coding the resource group name and location. In a real-world scenario, we would want to make this more dynamic and reusable. We can do this by using variables and modules.

## Files 2
- `variables.tf`: This file contains the variable definitions. It is similar to "package.json" in Node.js, this file specifies the variables and their default values.
- `environments/production.tfvars`: This file contains the variable values. Similar to ".env" in Node.js, this file specifies the environment variables and their values.

As we only have one environment, and all the variables have default values, we can directly reference the variables in our configuration files without needing to create multiple environment-specific files. But we are still going to create a `production.tfvars` file to show how it can be done. In a real-world scenario, we would have multiple environments (e.g., development, staging, production) and each environment would have its own set of variables. We can use the `-var-file` flag to specify the environment-specific variable file when running Terraform commands.
```bash
terraform plan -out main.tfplan -var-file=./environments/production.tfvars
```
```bash
terraform apply main.tfplan
```
```bash
terraform destroy -var-file="./environments/production.tfvars"
```
### Variables
- `resource_group_name`: The name of the resource group to be created. This variable is required and does not have a default value.
- `location`: The location where the resource group will be created. This variable is required and does not have a default value.

Another thing we can do is to use providers like `random` to generate random values for our variables. For example, we can use the `random_pet` resource to generate a random string for the resource group name. This way, we can focus on creating the infrastructure without worrying about naming conflicts. Usually we would like the name to be unique but still reflect the resource's purpose. 

```hcl
resource "random_pet" "name" {
  length = 1
}
```

`random_pet` might not be the most useful resource but `random` do offer other resources like `random_string` and `random_id` that can be used to generate random values, like an secure password. You can check the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/random/latest/docs) for more information on the available resources and their usage.

## Key Vault
- `keyvault.tf`: This file contains the configuration for creating a Key Vault.

To create a Key Vault let's start by adding some variables to our `variables.tf` file. We will add the following variables:
- `sku_name`: The SKU of the vault to be created. Standard or Premium.
- `key_permissions`: The permissions for the keys in the vault.
- `secret_permissions`: The permissions for the secrets in the vault. 


```hcl
# ---------------------------
# Azure Key Vault Variables
# ---------------------------

variable "sku_name" {
  type        = string
  description = "The SKU of the vault to be created."
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku_name must be one of the following: standard, premium."
  }
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions."
  default     = ["List"] # "Create", "Delete", "Get", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"
}

variable "secret_permissions" {
  type        = list(string)
  description = "List of secret permissions."
  default     = ["List", "Set", "Delete", "Get"]
}
```

Now we can use these variables in our `keyvault.tf` file to create a Key Vault. We will use the `azurerm_key_vault` resource to create the Key Vault with the access policies for the Key Vault.

```hcl
# ---------------------------
# Azure Key Vault
# ---------------------------
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
```

With that we have created a Key Vault with the specified SKU and access policies. We can also use the `azurerm_key_vault_secret` resource to create secrets in the Key Vault. For example, we can create a secret for the password generated by the `random_password` resource.

```hcl
# Generate Password for Key Vault Secret
resource "random_password" "password" {
  length           = 20
  special          = true
  override_special = "%&*()-_=+[]{}<>:?"
}

# Key Vault Entry
resource "azurerm_key_vault_secret" "key" {
  name         = "name-db-password"
  key_vault_id = azurerm_key_vault.kv.id
  value        = random_password.password.result
}
```

Remember to replace `name-db-password` with the name of the secret you want to create. 

This will create a secret in the Key Vault with the name `name-db-password` and the value of the password generated by the `random_password` resource. The password will be a random string of 20 characters with special characters.