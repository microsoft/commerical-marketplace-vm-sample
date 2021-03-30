# Configure the Microsoft Azure Provider
terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">=2.0.0"
        }
    }
}

provider "azurerm" {
    subscription_id = var.azure_subscription_id
    features {}
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "resourcegroup" {
    name     = "${var.base_name}rg"
    location = var.location

    tags = {
        environment = "${var.base_name} VM Verification"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "network" {
    name                = "${var.base_name}Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name

    tags = {
        environment = "${var.base_name} VM Verification"
    }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.base_name}Subnet"
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    virtual_network_name = azurerm_virtual_network.network.name
    address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "publicip" {
    name                         = "${var.base_name}IP"
    location                     = azurerm_resource_group.resourcegroup.location
    resource_group_name          = azurerm_resource_group.resourcegroup.name
    allocation_method            = "Dynamic"
    domain_name_label            = "${var.base_name}vm"

    tags = {
        environment = "${var.base_name} VM Verification"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.base_name}Nsg"
    location            = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name
    
    tags = {
        environment = "${var.base_name} VM Verification"
    }
}

resource "azurerm_network_security_rule" "wsrm1" {
  name                        = "RDP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "wsrm2" {
  name                        = "WinRM"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "${var.base_name}Nic"
    location                  = azurerm_resource_group.resourcegroup.location
    resource_group_name       = azurerm_resource_group.resourcegroup.name

    ip_configuration {
        name                          = "${var.base_name}NicConfiguration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }

    tags = {
        environment = "${var.base_name} VM Verification"
    }
}


resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.base_name}vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  vm_size               = var.vm_sku
  network_interface_ids = [azurerm_network_interface.nic.id]

  storage_image_reference {
    id = var.image_uri
  }

  storage_os_disk {
    name          = "${var.base_name}-osdisk1"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
      enable_automatic_upgrades = true
  }
}

