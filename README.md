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

