provider "azurerm" {
    version         = "=2.27.0"
    subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    client_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    tenant_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
features        {}
}


#create a resource group 
resource "azurerm_resource_group" "jkterraformrg" {
    name     = "jkResourceGroup"
    location = "eastus"

    tags = {
        environement = "Terraform Demo"
    }
}

#create network security group
resource "azurerm_network_security_group" "jkterraformnsg" {
    name                 = "jknsg"
    location             = azurerm_resource_group.jkterraformrg.location
    resource_group_name  = azurerm_resource_group.jkterraformrg.name
}


#create a virtual network
resource "azurerm_virtual_network" "jkterraformvnet" {
    name                = "jkvnet1"
    location            = azurerm_resource_group.jkterraformrg.location
    resource_group_name = azurerm_resource_group.jkterraformrg.name    
    address_space       = ["10.1.0.0/16"]
}

#create subnet
resource "azurerm_subnet" "jkterraformsubnet" {
    name                 = "subnet1"
    resource_group_name  = azurerm_resource_group.jkterraformrg.name
    virtual_network_name = azurerm_virtual_network.jkterraformvnet.name
    address_prefixes     = ["10.1.0.0/24"]

}

#create network interface
resource "azurerm_network_interface" "jkterraformnic" {
    name                = "jknic"
    location            = azurerm_resource_group.jkterraformrg.location
    resource_group_name = azurerm_resource_group.jkterraformrg.name

    ip_configuration {
        name                          = "jkniconfiguration"
        subnet_id                     = azurerm_subnet.jkterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

#create storage account for boot diagnotics

resource "azurerm_storage_account" "jkstorageaccount" {
    name                     = "jkstorageaccount1"
    resource_group_name      = azurerm_resource_group.jkterraformrg.name
    location                 = azurerm_resource_group.jkterraformrg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

#create virtual machine

resource "azurerm_virtual_machine" "jkterraformvm" {
    name                          = "jkvmT1"
    location                      = azurerm_resource_group.jkterraformrg.location
    resource_group_name           = azurerm_resource_group.jkterraformrg.name
    network_interface_ids         = [azurerm_network_interface.jkterraformnic.id]
    vm_size                       = "Standard_B1ls"

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

    # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "jkosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = "jkterravm1"
        admin_username = "jkterravm_test"
        admin_password = "jkterra@123!"
    }

#for linux
    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags = {
        environment = "experimenting"
    }
}