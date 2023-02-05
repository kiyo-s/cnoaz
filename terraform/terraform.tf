terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  storage_use_azuread = true
  features {}
}
