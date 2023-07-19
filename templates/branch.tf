#######################################################################
## Create Virtual Network - Onprem
#######################################################################

resource "azurerm_virtual_network" "onprem-vnet" {
  name                = "onprem-vnet"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["10.0.1.0/24","10.0.2.0/24"]

  tags = {
    environment = "onprem"
    deployment  = "terraform"
    microhack    ="vwan-security"
  }
}
#######################################################################
## Create Subnets - onprem
#######################################################################
resource "azurerm_subnet" "onprem-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes       = ["10.0.1.0/25"]
}
resource "azurerm_subnet" "bastion-onprem-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes       = ["10.0.1.192/26"]
}
resource "azurerm_subnet" "onprem-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes       = ["10.0.1.160/27"]
}
#######################################################################
## Create Virtual Network - Onprem2
#######################################################################

resource "azurerm_virtual_network" "onprem2-vnet" {
  name                = "onprem2-vnet"
  location            = var.location-onprem2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["10.0.3.0/24","10.0.4.0/24"]

  tags = {
    environment = "onprem2"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - onprem2
#######################################################################
resource "azurerm_subnet" "onprem2-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem2-vnet.name
  address_prefixes       = ["10.0.3.0/25"]
}
resource "azurerm_subnet" "bastion-onprem2-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem2-vnet.name
  address_prefixes       = ["10.0.3.192/26"]
}
resource "azurerm_subnet" "onprem2-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem2-vnet.name
  address_prefixes       = ["10.0.3.160/27"]
}
#######################################################################
## Create Virtual Network - onprem3
#######################################################################

resource "azurerm_virtual_network" "onprem3-vnet" {
  name                = "onprem3-vnet"
  location            = var.location-onprem3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["10.100.10.0/24","10.100.20.0/24"]

  tags = {
    environment = "onprem3"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Subnets - onprem3
#######################################################################
resource "azurerm_subnet" "onprem3-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem3-vnet.name
  address_prefixes       = ["10.100.10.0/25"]
}
resource "azurerm_subnet" "bastion-onprem3-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem3-vnet.name
  address_prefixes       = ["10.100.10.192/26"]
}
resource "azurerm_subnet" "onprem3-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem3-vnet.name
  address_prefixes       = ["10.100.10.160/27"]
}



#######################################################################
## Create Network Interface - Spoke onprem
#######################################################################

resource "azurerm_network_interface" "onprem-nic" {
  name                 = "onprem-nic"
  location             = var.location-onprem
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "onprem-ipconfig"
    subnet_id                     = azurerm_subnet.onprem-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "onprem"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Network Interface - Spoke onprem2
#######################################################################

resource "azurerm_network_interface" "onprem2-nic" {
  name                 = "onprem2-nic"
  location             = var.location-onprem2
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "onprem2-ipconfig"
    subnet_id                     = azurerm_subnet.onprem2-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "onprem2"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Network Interface - Spoke onprem3
#######################################################################
resource "azurerm_network_interface" "onprem3-nic" {
  name                 = "onprem3-nic"
  location             = var.location-onprem3
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "onprem3-ipconfig"
    subnet_id                     = azurerm_subnet.onprem3-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "onprem3"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine onprem
#######################################################################
resource "azurerm_windows_virtual_machine" "onprem-vm" {
  name                  = "onprem-vm"
  location              = var.location-onprem
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.onprem-nic.id]
  size               = var.vmsize
  computer_name  = "onprem-vm"
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
    name              = "onprem-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "onprem"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine onprem2
#######################################################################
resource "azurerm_windows_virtual_machine" "onprem2-vm" {
  name                  = "onprem2-vm"
  location              = var.location-onprem2
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.onprem2-nic.id]
  size               = var.vmsize
  computer_name  = "onprem2-vm"
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
    name              = "onprem2-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "onprem2"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}
#######################################################################
## Create Virtual Machine onprem3
#######################################################################
resource "azurerm_windows_virtual_machine" "onprem3-vm" {
  name                  = "onprem3-vm"
  location              = var.location-onprem3
  resource_group_name   = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids = [azurerm_network_interface.onprem3-nic.id]
  size               = var.vmsize
  computer_name  = "onprem3-vm"
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
    name              = "onprem2-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "onprem3"
    deployment  = "terraform"
    microhack    = "vwan-security"
  }
}