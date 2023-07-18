#######################################################################
## Create Virtual Network - Spoke 1
#######################################################################

resource "azurerm_virtual_network" "spoke-1-vnet" {
  name                = "spoke-1-vnet"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.1.0/24"]

  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}

#######################################################################
## Create Subnets - Spoke 1
#######################################################################

resource "azurerm_subnet" "spoke-1-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-1-vnet.name
  address_prefixes       = ["172.16.1.0/25"]
}
resource "azurerm_subnet" "bastion-spoke-1-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-1-vnet.name
  address_prefixes       = ["172.16.1.128/26"]
}
resource "azurerm_network_security_group" "spoke-1-nsg"{
    name = "spoke-1-nsg"
    location             = var.location-spoke-services
    resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
    security_rule = [  ]
        tags = {
      environment = "spoke-1"
      deployment  = "terraform"
      microhack    = "vwan-security"
    }
}
resource "azurerm_subnet_network_security_group_association" "spoke-1-vm-subnet-nsg-ass" {
  network_security_group_id = azurerm_network_security_group.spoke-1-nsg.id
  subnet_id = azurerm_subnet.spoke-1-vm-subnet.id
}

#######################################################################
## Create Virtual Network - Spoke 2
#######################################################################

resource "azurerm_virtual_network" "spoke-2-vnet" {
  name                = "spoke-2-vnet"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.2.0/24"]

  tags = {
    environment = "spoke-2"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - Spoke 2
#######################################################################
resource "azurerm_subnet" "spoke-2-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-2-vnet.name
  address_prefixes       = ["172.16.2.0/25"]
}
resource "azurerm_subnet" "bastion-spoke-2-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-2-vnet.name
  address_prefixes       = ["172.16.2.128/26"]
}
#######################################################################
## Create Virtual Network - Spoke 3
#######################################################################
resource "azurerm_virtual_network" "spoke-3-vnet" {
  name                = "spoke-3-vnet"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.3.0/24"]

  tags = {
    environment = "spoke-3"
    deployment  = "terraform"
    microhack    = "vwan"
  }
}
#######################################################################
## Create Subnets - Spoke 3
#######################################################################
resource "azurerm_subnet" "spoke-3-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-3-vnet.name
  address_prefixes       = ["172.16.3.0/25"]
}
resource "azurerm_subnet" "bastion-spoke-3-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-3-vnet.name
  address_prefixes       = ["172.16.3.128/26"]
}
#######################################################################
## Create Virtual Network - Spoke 4
#######################################################################

resource "azurerm_virtual_network" "spoke-4-vnet" {
  name                = "spoke-4-vnet"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.4.0/24"]

  tags = {
    environment = "spoke-4"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - Spoke 4
#######################################################################

resource "azurerm_subnet" "spoke-4-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-4-vnet.name
  address_prefixes       = ["172.16.4.0/25"]
}
resource "azurerm_subnet" "bastion-spoke-4-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-4-vnet.name
  address_prefixes       = ["172.16.4.128/26"]
}

#######################################################################
## Create Virtual Network - Services
#######################################################################
resource "azurerm_virtual_network" "services-vnet" {
  name                = "services-vnet"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.10.0/24"]

  tags = {
    environment = "services"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - Services
#######################################################################

resource "azurerm_subnet" "services-vm-1-subnet" {
  name                 = "servicesSubnet-1"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes       = ["172.16.10.0/25"]
}
resource "azurerm_subnet" "services-vm-2-subnet" {
  name                 = "servicesSubnet-2"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes       = ["172.16.10.128/26"]
}
resource "azurerm_subnet" "bastion-services-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes       = ["172.16.10.192/26"]
}
#######################################################################
## Create Virtual Network - NVA
#######################################################################
resource "azurerm_virtual_network" "nva-vnet" {
  name                = "nva-vnet"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.20.0/24"]

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - NVA
#######################################################################

resource "azurerm_subnet" "nva-trust-subnet" {
  name                 = "nva-trust-subnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes       = ["172.16.20.0/26"]
}
resource "azurerm_subnet" "nva-untrust-subnet" {
  name                 = "nva-untrust-subnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes       = ["172.16.20.64/26"]
}
resource "azurerm_subnet" "bastion-nva-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes       = ["172.16.20.160/27"]
}
resource "azurerm_network_security_group" "nva-untrust-nsg"{
    name = "nva-untrust-nsg"
    location             = var.location-spoke-services
    resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name

   
    security_rule {
    name                       = "http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
    security_rule {
    name                       = "https"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
    security_rule {
    name                       = "bgp"
    priority                   = 230
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "179"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
    security_rule {
    name                       = "icmp"
    priority                   = 220
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes     = ["172.16.0.0/12","10.0.0.0/8"]
    destination_address_prefix = "*"
    }

    tags = {
      environment = "nva"
      deployment  = "terraform"
      microhack    = "vwan-security"
    }
}
resource "azurerm_subnet_network_security_group_association" "nva-nsg-ass" {
  subnet_id      = azurerm_subnet.nva-untrust-subnet.id
  network_security_group_id = azurerm_network_security_group.nva-untrust-nsg.id
}
#######################################################################
## Create Network Interface - Spoke 1
#######################################################################
resource "azurerm_public_ip" "spoke-1-vm-pub-ip"{
    name                 = "spoke-1-vm-pub-ip"
    location             = var.location-spoke-services
    resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    tags = {
      environment = "spoke-1"
      deployment  = "terraform"
      microhack    = "vwan-security"
    }
}
resource "azurerm_network_interface" "spoke-1-nic" {
  name                 = "spoke-1-nic"
  location             = var.location-spoke-1
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false
  ip_configuration {
    name                          = "spoke-1-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-1-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.spoke-1-vm-pub-ip.id
  }
  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Network Interface - Spoke 2
#######################################################################

resource "azurerm_network_interface" "spoke-2-nic" {
  name                 = "spoke-2-nic"
  location             = var.location-spoke-2
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-2-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-2-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Network Interface - Spoke 3
#######################################################################

resource "azurerm_network_interface" "spoke-3-nic" {
  name                 = "spoke-3-nic"
  location             = var.location-spoke-3
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-3-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-3-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-3"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Network Interface - Spoke 4
#######################################################################

resource "azurerm_network_interface" "spoke-4-nic" {
  name                 = "spoke-4-nic"
  location             = var.location-spoke-4
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-4"
    subnet_id                     = azurerm_subnet.spoke-4-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-4"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}

/*
#######################################################################
## Create Network Interface - ADDC
#######################################################################

resource "azurerm_network_interface" "spoke-addc-1-nic" {
  name                 = "spoke-addc-1-nic"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "addc-1-ipconfig"
    subnet_id                     = azurerm_subnet.services-vm-1-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "services"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}*/
#######################################################################
## Create Virtual Machine spoke-1
#######################################################################

resource "azurerm_windows_virtual_machine" "spoke-1-vm" {
  name                  = "spoke-1-vm"
  location              = var.location-spoke-1
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.spoke-1-nic.id]
  size               = var.vmsize
  computer_name  = "spoke-1-vm"
  admin_username = var.username
  admin_password = var.password
  provision_vm_agent = true

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name              = "spoke-1-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  
  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine spoke-2
#######################################################################
resource "azurerm_windows_virtual_machine" "spoke-2-vm" {
  name                  = "spoke-2-vm"
  location              = var.location-spoke-2
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.spoke-2-nic.id]
  size               = var.vmsize
  computer_name  = "spoke-2-vm"
  admin_username = var.username
  admin_password = var.password
  provision_vm_agent = true
  

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name              = "spoke-2-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "spoke-2"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine spoke-3
#######################################################################
resource "azurerm_windows_virtual_machine" "spoke-3-vm" {
  name                  = "spoke-3-vm"
  location              = var.location-spoke-3
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.spoke-3-nic.id]
  size               = var.vmsize
  computer_name  = "spoke-3-vm"
  admin_username = var.username
  admin_password = var.password
  provision_vm_agent = true

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name              = "spoke-3-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "spoke-3"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine spoke-4
#######################################################################
resource "azurerm_windows_virtual_machine" "spoke-4-vm" {
  name                  = "spoke-4-vm"
  location              = var.location-spoke-4
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.spoke-4-nic.id]
  size               = var.vmsize
  computer_name  = "spoke-4-vm"
  admin_username = var.username
  admin_password = var.password
  provision_vm_agent = true

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name              = "spoke-4-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "spoke-4"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}

/*
#######################################################################
## Create Virtual Machine spoke-addc
#######################################################################
resource "azurerm_windows_virtual_machine" "spoke-addc-vm" {
  name                  = "spoke-addc-vm"
  location              = var.location-spoke-services
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.spoke-addc-1-nic.id]
  size               = var.vmsize
  computer_name  = "spoke-addc-vm"
  admin_username = var.username
  admin_password = var.password
  provision_vm_agent = true

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    name              = "spoke-addc-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "addc"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}*/
/*
#######################################################################
## Create Network Interface - nva-iptables-vm
#######################################################################
resource "azurerm_public_ip" "nva-iptables-vm-pub-ip"{
    name                 = "nva-iptables-vm-pub-ip"
    location             = var.location-spoke-services
    resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    tags = {
      environment = "nva"
      deployment  = "terraform"
      microhack    = "vwan-security"
    }
}

resource "azurerm_network_interface" "nva-iptables-vm-nic-1" {
  name                 = "nva-iptables-vm-nic-1"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "nva-1-ipconfig"
    subnet_id                     = azurerm_subnet.untrust-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "172.16.20.63"
    public_ip_address_id = azurerm_public_ip.nva-iptables-vm-pub-ip.id
  }
  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine - NVA
#######################################################################
resource "azurerm_linux_virtual_machine" "nva-iptables-vm" {
  name                  = "nva-iptables-vm"
  location              = var.location-spoke-services
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.nva-iptables-vm-nic-1.id]
  size               = var.vmsize
  admin_username = var.username
  admin_password = var.password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "nva-iptables-vm-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }  

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}*/
#######################################################################
## Create Network Interface - nva-csr-vm
#######################################################################
resource "azurerm_public_ip" "nva-csr-vm-pub-ip"{
    name                 = "nva-csr-vm-pub-ip"
    location             = var.location-spoke-services
    resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    tags = {
      environment = "nva"
      deployment  = "terraform"
      microhack    = "vwan-security"
    }
}
resource "azurerm_network_interface" "nva-csr-vm-nic-1" {
  name                 = "nva-csr-vm-nic-1"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "nva-csr-1-ipconfig"
    subnet_id                     = azurerm_subnet.nva-trust-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "172.16.20.4"
  }
  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
resource "azurerm_network_interface" "nva-csr-vm-nic-2" {
  name                 = "nva-csr-vm-nic-2"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "nva-csr-2-ipconfig"
    subnet_id                     = azurerm_subnet.nva-untrust-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "172.16.20.68"
    public_ip_address_id = azurerm_public_ip.nva-csr-vm-pub-ip.id
  }
  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine - CSR
#######################################################################
resource "azurerm_linux_virtual_machine" "nva-csr-vm" {
  name                  = "nva-csr-vm"
  location              = var.location-spoke-services
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.nva-csr-vm-nic-1.id, azurerm_network_interface.nva-csr-vm-nic-2.id]
  size               = var.vmsize
  admin_username = var.username
  admin_password = var.password
  disable_password_authentication = false
  boot_diagnostics {
    
  }

  plan {
    name = "16_12_5-byol"
    publisher = "cisco"
    product = "cisco-csr-1000v"
  }

  source_image_reference {
    publisher = "cisco"
    offer = "cisco-csr-1000v"
    sku = "16_12_5-byol"
    version = "latest"
  }
  os_disk {
    name              = "nva-csr-vm-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }  
  custom_data = "U2VjdGlvbjogSU9TIGNvbmZpZ3VyYXRpb24KaG9zdG5hbWUgY3NyLW5hCmludGVyZmFjZSBHaWdhYml0RXRoZXJuZXQxCmlwIGFkZHJlc3MgZGhjcAppbnRlcmZhY2UgR2lnYWJpdEV0aGVybmV0MgppcCBhZGRyZXNzIGRoY3AKIWRlZmF1bHQgcm91dGUgcG9pbnRpbmcgdG8gR2lnRTIgd2hpY2ggaGFzIHB1YmxpYyBJUAppcCByb3V0ZSAwLjAuMC4wIDAuMC4wLjAgR2lnYWJpdEV0aGVybmV0MiAxNzIuMTYuMjAuNjUKIXJlbW92ZSBkZWZhdWx0IHJvdXRlIHBvaW50aW5nIHRvIEdpZ0UxCm5vIGlwIHJvdXRlIDAuMC4wLjAgMC4wLjAuMCBHaWdhYml0RXRoZXJuZXQxIDE3Mi4xNi4yMC4xCiEgc3RhdGljIHJvdXRlIHRvIFZXQU4gSHViIHN1Ym5ldCBwb2ludGluZyB0byBDU1Igc3VibmV0IGRlZmF1bHQgZ2F0ZXdheSwgdG8gcHJldmVudCByZWN1cnNpdmUgcm91dGluZyBmYWlsdXJlIGZvciBWV0FOIEh1YiBlbmRwb2ludCBhZGRyZXNzZXMgbGVhcm5lZCB2aWEgQkdQIGZyb20gSHViCmlwIHJvdXRlIDE5Mi4xNjguMC4wIDI1NS4yNTUuMjU1LjAgMTcyLjE2LjIwLjEKISBzdGF0aWMgcm91dGVzIGZvciBPbnByZW0yIEdhdGV3YXlTdWJuZXQgcG9pbnRpbmcgdG8gVHVubmVsMTAxIGFuZCBUdW5uZWwxMDIsIHNvIHRoYXQgQnJhbmNoMUdXIEJHUCBwZWVyIGFkZHJlc3MgaXMgcmVhY2hhYmxlCmlwIHJvdXRlIDEwLjAuMy4xNjQgMjU1LjI1NS4yNTUuMjU1IFR1bm5lbDEwMQppcCByb3V0ZSAxMC4wLjMuMTY1IDI1NS4yNTUuMjU1LjI1NSBUdW5uZWwxMDIKIQpyb3V0ZXIgYmdwIDY0MDAwCm5laWdoYm9yIDE5Mi4xNjguMC42OCByZW1vdGUtYXMgNjU1MTUKbmVpZ2hib3IgMTkyLjE2OC4wLjY4IGViZ3AtbXVsdGlob3AgMjU1Cm5laWdoYm9yIDE5Mi4xNjguMC42OSByZW1vdGUtYXMgNjU1MTUKbmVpZ2hib3IgMTkyLjE2OC4wLjY5IGViZ3AtbXVsdGlob3AgMjU1Cm5laWdoYm9yIDEwLjAuMy4xNjQgcmVtb3RlLWFzIDY0MjAwCm5laWdoYm9yIDEwLjAuMy4xNjQgYmdwLW11bHRpaG9wIDI1NQpuZWlnaGJvciAxMC4wLjMuMTY1IHJlbW90ZS1hcyA2NDIwMApuZWlnaGJvciAxMC4wLjMuMTY1IGJncC1tdWx0aWhvcCAyNTUKIQpjcnlwdG8gaWtldjIgcHJvcG9zYWwgYXp1cmUtcHJvcG9zYWwtY29ubmVjdGlvblMxSHViQ1NSIAogZW5jcnlwdGlvbiBhZXMtY2JjLTI1NiBhZXMtY2JjLTEyOAogaW50ZWdyaXR5IHNoYTEgc2hhMjU2CiBncm91cCAyCiEKY3J5cHRvIGlrZXYyIHBvbGljeSBhenVyZS1wb2xpY3ktY29ubmVjdGlvblMxSHViQ1NSIAogcHJvcG9zYWwgYXp1cmUtcHJvcG9zYWwtY29ubmVjdGlvblMxSHViQ1NSCiFSZXBsYWNlIDEuMS4xLjEgYW5kIDEuMS4xLjIgd2l0aCBwcmltYXJ5IGFuZCBzZWNvbmRheSBwdWJsaWMgSVBzIG9mIHZuZXQtZ3ctb25wcmVtMgpjcnlwdG8gaWtldjIga2V5cmluZyBhenVyZS1rZXlyaW5nCiBwZWVyIE9ucHJlbTJWUE5HV1B1YklwVjQxCiAgYWRkcmVzcyAxLjEuMS4xCiAgcHJlLXNoYXJlZC1rZXkgTWljcm9oYWNrMjAyMwogcGVlciBPbnBybWUyVlBOR1dQdWJJcFY0MgogIGFkZHJlc3MgMS4xLjEuMgogIHByZS1zaGFyZWQta2V5IE1pY3JvaGFjazIwMjMKIQpjcnlwdG8gaWtldjIgcHJvZmlsZSBhenVyZS1wcm9maWxlLWNvbm5lY3Rpb25PbnByZW0ySHViQ1NSCiBtYXRjaCBhZGRyZXNzIGxvY2FsIGludGVyZmFjZSBHaWdhYml0RXRoZXJuZXQxCiBtYXRjaCBpZGVudGl0eSByZW1vdGUgYWRkcmVzcyAxLjEuMS4xIDI1NS4yNTUuMjU1LjI1NSAKIG1hdGNoIGlkZW50aXR5IHJlbW90ZSBhZGRyZXNzIDEuMS4xLjIgMjU1LjI1NS4yNTUuMjU1IAogYXV0aGVudGljYXRpb24gcmVtb3RlIHByZS1zaGFyZQogYXV0aGVudGljYXRpb24gbG9jYWwgcHJlLXNoYXJlCiBrZXlyaW5nIGxvY2FsIGF6dXJlLWtleXJpbmcKIGxpZmV0aW1lIDI4ODAwCiBkcGQgMTAgNSBvbi1kZW1hbmQKIQogY3J5cHRvIGlwc2VjIHRyYW5zZm9ybS1zZXQgYXp1cmUtaXBzZWMtcHJvcG9zYWwtc2V0IGVzcC1hZXMgMjU2IGVzcC1zaGEyNTYtaG1hYyAKIG1vZGUgdHVubmVsCiEKY3J5cHRvIGlwc2VjIHByb2ZpbGUgYXp1cmUtaXBzZWMtb25wcmVtMgogc2V0IHNlY3VyaXR5LWFzc29jaWF0aW9uIGxpZmV0aW1lIGtpbG9ieXRlcyAxMDI0MDAwMDAKIHNldCB0cmFuc2Zvcm0tc2V0IGF6dXJlLWlwc2VjLXByb3Bvc2FsLXNldCAKIHNldCBpa2V2Mi1wcm9maWxlIGF6dXJlLXByb2ZpbGUtY29ubmVjdGlvbk9ucHJlbTJIdWJDU1IKIQppbnRlcmZhY2UgVHVubmVsMTAxCiBpcCBhZGRyZXNzIDEwLjAuMTAwLjQgMjU1LjI1NS4yNTUuMjU0CiBpcCB0Y3AgYWRqdXN0LW1zcyAxMzUwCiB0dW5uZWwgc291cmNlIEdpZ2FiaXRFdGhlcm5ldDIKIHR1bm5lbCBtb2RlIGlwc2VjIGlwdjQKIHR1bm5lbCBkZXN0aW5hdGlvbiAxLjEuMS4xCiB0dW5uZWwgcHJvdGVjdGlvbiBpcHNlYyBwcm9maWxlIGF6dXJlLWlwc2VjLW9ucHJlbTIKIQppbnRlcmZhY2UgVHVubmVsMTAyCiBpcCBhZGRyZXNzIDEwLjAuMTAwLjYgMjU1LjI1NS4yNTUuMjU0CiBpcCB0Y3AgYWRqdXN0LW1zcyAxMzUwCiB0dW5uZWwgc291cmNlIEdpZ2FiaXRFdGhlcm5ldDIKIHR1bm5lbCBtb2RlIGlwc2VjIGlwdjQKIHR1bm5lbCBkZXN0aW5hdGlvbiAxLjEuMS4yCiB0dW5uZWwgcHJvdGVjdGlvbiBpcHNlYyBwcm9maWxlIGF6dXJlLWlwc2VjLW9ucHJlbTI="
    tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}


