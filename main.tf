 # Set the remote backend and workspace
 terraform {
   backend "remote" {
     # The name of your Terraform Cloud organization.
     organization = "arma-automation"
     workspaces {
       name = "arma-automation"
     }
   }
 }

# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features{}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "arma-resource-group" {
    name     = "ArmaResourceGroup"
    location = "australiaeast"

    tags = {
        environment = "Arma Automation"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "armaterraformnetwork" {
    name                = "armaVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "australiaeast"
    resource_group_name = azurerm_resource_group.arma-resource-group.name

    tags = {
        environment = "Arma Automation"
    }
}

# Create subnet
resource "azurerm_subnet" "armaterraformsubnet" {
    name                 = "armaSubnet"
    resource_group_name  = azurerm_resource_group.arma-resource-group.name
    virtual_network_name = azurerm_virtual_network.armaterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "armaterraformpublicip" {
    name                         = "armaPublicIP"
    location                     = "australiaeast"
    resource_group_name          = azurerm_resource_group.arma-resource-group.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Arma Automation"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "armaterraformnsg" {
    name                = "armaNetworkSecurityGroup"
    location            = "australiaeast"
    resource_group_name = azurerm_resource_group.arma-resource-group.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

  security_rule {
        name                       = "Steam"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "2302"
        destination_port_range     = "2304"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Arma Automation"
    }
}

# Create network interface
resource "azurerm_network_interface" "armaterraformnic" {
    name                      = "armaNIC"
    location                  = "australiaeast"
    resource_group_name       = azurerm_resource_group.arma-resource-group.name

    ip_configuration {
        name                          = "armaNicConfiguration"
        subnet_id                     = azurerm_subnet.armaterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.armaterraformpublicip.id
    }

    tags = {
        environment = "Arma Automation"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.armaterraformnic.id
    network_security_group_id = azurerm_network_security_group.armaterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.arma-resource-group.name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "armastorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.arma-resource-group.name
    location                    = "australiaeast"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Arma Automation"
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "arma_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.arma_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "armaterraformvm" {
    name                  = "armaVM"
    location              = "australiaeast"
    resource_group_name   = azurerm_resource_group.arma-resource-group.name
    network_interface_ids = [azurerm_network_interface.armaterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "armaOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "armavm"
    admin_username = "armaadmin"
    admin_password = "AbsoluteTesting123%%"
    disable_password_authentication = false
        
    admin_ssh_key {
        username       = "armaadmin"
        public_key     = tls_private_key.arma_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.armastorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Arma Automation"
    }
}