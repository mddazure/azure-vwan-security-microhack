resource "azurerm_firewall_policy" "microhack-fw-parent-policy" {
    name = "microhack-fw-parent-policy"
    location = var.location-vwan-we-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    sku = "Premium"

}

resource "azurerm_firewall_policy" "microhack-fw-we-child-policy" {
    name = "microhack-fw-we-child-policy"
    location = var.location-vwan-we-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    base_policy_id = azurerm_firewall_policy.microhack-fw-parent-policy.id
    sku = "Premium"
  
}

resource "azurerm_firewall_policy" "microhack-fw-useast-child-policy" {
    name = "microhack-fw-useast-child-policy"
    location = var.location-vwan-useast-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    base_policy_id = azurerm_firewall_policy.microhack-fw-parent-policy.id
    sku = "Premium"
}

resource "azurerm_firewall_policy_rule_collection_group" "we-useast-rule-coll-grp" {
    name = "we-useast-rule-coll-grp"
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-parent-policy.id
    priority = 500
    network_rule_collection {
      name = "we-useast-network-rule-coll"
      priority = 200
      action = "Allow"
      rule {
        name ="spoke1-spoke4"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.1.0/24"]
        destination_addresses     = ["172.16.4.0/24"]
        destination_ports         = ["80"]
      }
        rule {
        name ="spoke4-spoke1"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.4.0/24"]
        destination_addresses     = ["172.16.1.0/24"]
        destination_ports         = ["80"]
      }
    }
  
}

resource "azurerm_firewall_policy_rule_collection_group" "we-rule-coll-grp" {
    name = "we-rule-coll-grp"
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-we-child-policy.id
    priority = 600
    network_rule_collection {
      name = "we-network-rule-coll"
      priority = 200
      action = "Allow"
      rule {
        name ="spoke1-spoke2,services"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.1.0/24"]
        destination_addresses     = ["172.16.2.0/24","172.16.10.0/24"]
        destination_ports         = ["80"]
      }
      rule {
        name = "spoke1-branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.1.0/24"]
        destination_addresses     = ["10.0.1.0/24","10.0.21.0/24"]
        destination_ports         = ["80"]
      }
            rule {
        name = "branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["10.0.1.0/24"]
        destination_addresses     = ["10.0.21.0/24"]
        destination_ports         = ["80"]
      }
    }
}
resource "azurerm_firewall_policy_rule_collection_group" "useast-rule-coll-grp" {
    name = "useast-rule-coll-grp"
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-useast-child-policy.id
    priority = 700
    network_rule_collection {
      name = "useast-network-rule-coll"
      priority = 200
      action = "Allow"
      rule {
        name ="spoke3-spoke4,services"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.3.0/24"]
        destination_addresses     = ["172.16.4.0/24","172.16.10.0/24"]
        destination_ports         = ["80"]
      }
      rule {
        name = "spoke3-branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.3.0/24"]
        destination_addresses     = ["10.0.1.0/24","10.0.21.0/24"]
        destination_ports         = ["80"]
      }
    }
  
}