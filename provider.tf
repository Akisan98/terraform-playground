terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # https://registry.terraform.io/providers/hashicorp/azurerm/4.0.0/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory
  # subscription_id = "00000-xxxxx-xxxxx-xxxxx" # Required from version 4.0.0 
}