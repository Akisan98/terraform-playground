variable "resource_group_location" {
  type        = string
  default     = "Norway East" # Or West Europe
  description = "Location of the resource group."
}

variable "resource_group_name_postfix" {
  type        = string
  default     = "rg"
  description = "Postfix of the resource group name that's combined with a random pet so name is unique in your Azure subscription."
}