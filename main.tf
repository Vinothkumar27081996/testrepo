##############################################################
# Terraform Storage Account Example
##############################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

##############################################################
# Variables
##############################################################
variable "resource_group_name" {
  description = "Resource group name"
  default = myrg453
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase letters/numbers)"
  default = vinopravin123
  type        = string
}

##############################################################
# Resource Group (optional - if you don’t already have one)
##############################################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

##############################################################
# Storage Account
##############################################################
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Options: LRS, GRS, RAGRS, ZRS, GZRS

  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  tags = {
    environment = "dev"
    owner       = "vinoth"
  }
}

##############################################################
# Storage Containers
##############################################################
resource "azurerm_storage_container" "example" {
  name                  = "tfcontainer"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private" # options: private, blob, container
}

##############################################################
# Outputs
##############################################################
output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}
