#terraform {
#  required_providers {
#    azurerm = {
#      source  = "hashicorp/azurerm"
#      version = "3.116.0"
#    }
#  }
#}

provider "azurerm" {
  features {}
}
#######################################################################
## Create Resource Group
#######################################################################

resource "azurerm_resource_group" "vwan-microhack-spoke-rg" {
  name     = "vwan-security-microhack-spoke-rg"
  location = var.location-spoke-1
 tags = {
    environment = "spoke"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}

resource "azurerm_resource_group" "vwan-microhack-hub-rg" {
  name     = "vwan-security-microhack-hub-rg"
  location = var.location-vwan
 tags = {
    environment = "hub"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
