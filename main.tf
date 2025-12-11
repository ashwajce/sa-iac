provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = "${var.region}"

  tags = {
    Environment = "dev"
    Project     = "storage-project"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_account" "main" {
  # Storage account names must be globally unique and can only contain lowercase letters and numbers.
  # They must be between 3 and 24 characters in length.
  # The provided name 'test' might be too common and not meet uniqueness requirements in Azure.
  name                     = "${var.storage_account_name}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS" # Geo-Redundant Storage for high durability
  access_tier              = "Hot"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true # Set to false to restrict public access; configure 'network_rules' for specific access
  default_to_oauth_authentication = true

  # Enable blob service properties for enterprise best practices
  blob_properties {
    versioning_enabled        = true
    change_feed_enabled       = true
    last_access_time_enabled  = true
    container_delete_retention_policy {
      days = 7 # Retain deleted containers for 7 days
    }
    delete_retention_policy {
      days = 7 # Retain deleted blobs for 7 days
    }
  }

  tags = {
    Environment = "dev"
    Project     = "storage-project"
    Owner       = "DevOpsTeam"
    ManagedBy   = "Terraform"
  }
}

# Create a default container within the storage account
resource "azurerm_storage_container" "default_container" {
  name                  = "general-purpose"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private" # Recommended for security
}
