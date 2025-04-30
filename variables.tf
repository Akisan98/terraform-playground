variable "resource_group_location" {
  type        = string
  default     = "Norway East" # Or West Europe
  description = "Location of the resource group."
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment name (e.g., dev, test, prod)."
  validation {
    condition     = contains(["prod"], var.environment) # "dev", "test", 
    error_message = "The environment must be either 'prod'."
  }
}


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