#######################################################################
## Create VNET Gateway - onprem2
#######################################################################
resource "azurerm_public_ip" "vnet-gw-onprem3-pubip-1" {
    name                = "vnet-gw-onprem3-pubip-1"
    location            = var.location-onprem3
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = ["1","2","3"]    
  }
  
  resource "azurerm_public_ip" "vnet-gw-onprem3-pubip-2" {
    name                = "vnet-gw-onprem3-pubip-2"
    location            = var.location-onprem3
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = ["1","2","3"]    
  }
  resource "azurerm_virtual_network_gateway" "vnet-gw-onprem3" {
    name                = "vnet-gw-onprem3"
    location            = var.location-onprem3
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  
    type     = "Vpn"
    vpn_type = "RouteBased"
  
    active_active = true
    enable_bgp    = true
    sku           = "VpnGw1AZ"
  
    bgp_settings{
      asn = 64300
    } 

    ip_configuration {
      name                          = "vnet-gw-onprem3-ip-config-1"
      public_ip_address_id          = azurerm_public_ip.vnet-gw-onprem3-pubip-1.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.onprem3-gateway-subnet.id
    }
    ip_configuration {
      name                          = "vnet-gw-onprem3-ip-config-2"
      public_ip_address_id          = azurerm_public_ip.vnet-gw-onprem3-pubip-2.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.onprem3-gateway-subnet.id
    }
  }
  resource "azurerm_local_network_gateway" "lng-csr" {
    name = "lng-csr"
    location = var.location-onprem3
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    gateway_address = azurerm_public_ip.nva-csr-vm-pub-ip.ip_address
    bgp_settings {
      asn = 64000
      bgp_peering_address = azurerm_network_interface.nva-csr-vm-nic-2.private_ip_address
    }    
  }
  resource "azurerm_virtual_network_gateway_connection" "to-csr" {
    name = "to-csr"
    location = var.location-onprem3
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    type = "IPsec"
    virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet-gw-onprem3.id
    local_network_gateway_id = azurerm_local_network_gateway.lng-csr.id
    shared_key = "Microhack2023"    
  }