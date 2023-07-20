resource "azurerm_ip_group" "spoke-ip-group" {
  name = "spoke-ip-group"
  location = var.location-vwan-we-hub
  resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
  cidrs = ["172.16.1.0/24","172.16.2.0/24","172.16.3.0/24","172.16.4.0/24","172.16.10.0/24","172.16.20.0/24"]
}

resource "azurerm_ip_group" "branch-ip-group" {
  name = "branch-ip-group"
  location = var.location-vwan-we-hub
  resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
  cidrs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
}
resource "azurerm_ip_group" "sdwan-ip-group" {
  name = "sdwan-ip-group"
  location = var.location-vwan-we-hub
  resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
  cidrs = ["10.100.10.0/24","10.100.20.0/24"]
}
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
    location = var.location-vwan-we-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    base_policy_id = azurerm_firewall_policy.microhack-fw-parent-policy.id
    sku = "Premium"
}

resource "azurerm_firewall_policy_rule_collection_group" "parent-we-useast-rule-coll-grp" {
    name = "parent-we-useast-rule-coll-grp"
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
      rule {
        name ="rdp-from-services-to-all"
        protocols                 = ["TCP"]
        source_addresses          = ["172.16.10.0/24"]
        destination_addresses     = ["*"]
        destination_ports         = ["3389"]
      }
    }
    application_rule_collection {
      name = "we-useast-application-rule-coll"
      priority = 500
      action = "Allow" 
      rule {
        name = "internet"
        source_ip_groups = [azurerm_ip_group.spoke-ip-group.id,azurerm_ip_group.branch-ip-group.id]
        destination_fqdn_tags = ["Business","Computers + technology","Information security","General"]
        protocols {
          port = "80"
          type = "Http"
          }
      }     
    }
}

resource "azurerm_firewall_policy_rule_collection_group" "child-we-rule-coll-grp" {
    name = "child-we-rule-coll-grp"
    firewall_policy_id = azurerm_firewall_policy.microhack-fw-we-child-policy.id
    priority = 600
    network_rule_collection {
      name = "we-network-rule-coll"
      priority = 200
      action = "Allow"
      rule {
        name ="spoke1-spoke2"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.1.0/24","172.16.2.0/24"]
        destination_addresses     = ["172.16.2.0/24","172.16.1.0/24"]
        destination_ports         = ["80"]
      }
      rule {
        name = "spoke1-branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_addresses          = ["172.16.1.0/24"]
        destination_addresses     = ["10.0.1.0/24","10.0.3.0/24"]
        destination_ports         = ["80"]
      }
    }
      network_rule_collection {
      name = "we-deny-private-network-rule-coll"
      priority = 250
      action = "Deny"
      rule {
        name ="deny spokes-branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_ip_groups          = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id,azurerm_ip_group.branch-ip-group]
        destination_ip_groups     = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id,azurerm_ip_group.branch-ip-group]
        destination_ports         = ["*"]
      }
    }
      network_rule_collection {
      name = "we-allow-any-network-rule-coll"
      priority = 300
      action = "Allow"
      rule {
        name ="allow to internet"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_ip_groups          = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id,azurerm_ip_group.branch-ip-group]
        destination_addresses     = ["*"]
        destination_ports         = ["*"]
      }
    }
}
resource "azurerm_firewall_policy_rule_collection_group" "child-useast-rule-coll-grp" {
    name = "child-useast-rule-coll-grp"
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
      network_rule_collection {
      name = "useast-deny-private-network-rule-coll"
      priority = 250
      action = "Deny"
      rule {
        name ="spokes-branches"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_ip_groups          = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id]
        destination_ip_groups     = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id]
        destination_ports         = ["*"]
      }
    }
      network_rule_collection {
      name = "useast-allow-any-network-rule-coll"
      priority = 300
      action = "Allow"
      rule {
        name ="any"
        protocols                 = ["TCP", "UDP", "ICMP"]
        source_ip_groups          = [azurerm_ip_group.branch-ip-group.id,azurerm_ip_group.spoke-ip-group.id]
        destination_addresses     = ["*"]
        destination_ports         = ["*"]
      }
    } 
}