terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Ensures you use the stable 3.x version
    }
  }
}

provider "azurerm" {
  features {
    # This block is required for the Azure RM provider
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}