 
  resource "azurerm_virtual_wan" "microhack-vwan" {
    name                = "microhack-vwan"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan
  }
  ###############################
  ### West Europe Secured Hub ###
  ###############################
  resource "azurerm_virtual_hub" "microhack-we-hub" {
    name                = "microhack-we-secured-hub"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan-we-hub
    virtual_wan_id      = azurerm_virtual_wan.microhack-vwan.id
    address_prefix      = "192.168.0.0/24"
  }
  /*resource "azurerm_firewall" "microhack-we-hub-firewall" {
    name                = "microhack-we-hub-firewall"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan-we-hub
    sku_name = "virtual_hub"
    sku_tier = "Premium"
    virtual_hub {
      virtual_hub_id = microhack-we-hub.virtual_hub_id
      public_ip_count = 1
    }
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-we-child-policy.id
  }
  resource "azurerm_vpn_gateway" "microhack-we-hub-vng" {
    name                = "microhack-we-hub-vng"
    location            = var.location-vwan-we-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    virtual_hub_id      = azurerm_virtual_hub.microhack-we-hub.id
    timeouts {
      create = "4h"
      update = "4h"
      read = "10m"
      delete = "4h"
    }
  }*/
  resource "azurerm_virtual_hub_connection" "we-spoke1-conn" {
    name = "we-spoke1-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-we-hub.id
    remote_virtual_network_id = azurerm_virtual_network.spoke-1-vnet.id    
  }
  resource "azurerm_virtual_hub_connection" "we-spoke2-conn" {
    name = "we-spoke2-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-we-hub.id
    remote_virtual_network_id = azurerm_virtual_network.spoke-2-vnet.id    
  }
  resource "azurerm_virtual_hub_connection" "we-services-conn" {
    name = "we-services-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-we-hub.id
    remote_virtual_network_id = azurerm_virtual_network.services-vnet.id    
  }
    resource "azurerm_virtual_hub_connection" "we-nva-conn" {
    name = "we-nva-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-we-hub.id
    remote_virtual_network_id = azurerm_virtual_network.nva-vnet.id    
  }


  ###########################
  ### US East Secured Hub ###
  ###########################
  resource "azurerm_virtual_hub" "microhack-useast-hub" {
    name                = "microhack-useast-secured-hub"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan-useast-hub
    virtual_wan_id      = azurerm_virtual_wan.microhack-vwan.id
    address_prefix      = "192.168.1.0/24"
  }
  /*resource "azurerm_firewall" "microhack-useast-hub-firewall" {
    name                = "microhack-useast-hub-firewall"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan-useast-hub
    sku_name = "virtual_hub"
    sku_tier = "Premium"
    virtual_hub {
      virtual_hub_id = microhack-useast-hub.virtual_hub_id
      public_ip_count = 1
    }
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-useast-child-policy.id
  }
    resource "azurerm_vpn_gateway" "microhack-useast-hub-vng" {
    name                = "microhack-useast-hub-vng"
    location            = var.location-vwan-useast-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    virtual_hub_id      = azurerm_virtual_hub.microhack-useast-hub.id
    timeouts {
      create = "4h"
      update = "4h"
      read = "10m"
      delete = "4h"
    }
  }*/
    resource "azurerm_virtual_hub_connection" "useast-spoke3-conn" {
    name = "useast-spoke3-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-useast-hub.id
    remote_virtual_network_id = azurerm_virtual_network.spoke-3-vnet.id    
  }
  resource "azurerm_virtual_hub_connection" "useast-spoke4-conn" {
    name = "useast-spoke4-conn"
    virtual_hub_id = azurerm_virtual_hub.microhack-useast-hub.id
    remote_virtual_network_id = azurerm_virtual_network.spoke-4-vnet.id    
  }
