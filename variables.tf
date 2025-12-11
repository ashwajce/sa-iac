variable "region" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique name for the Azure Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
}
