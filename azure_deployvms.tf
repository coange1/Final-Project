# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "FinalProject" {
  name     = "terraform-resources"
  location = "canadacentral"
}

# Create a virtual network
resource "azurerm_virtual_network" "vmtf" {
  name                = "tfnetwork"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.FinalProject.location
  resource_group_name = azurerm_resource_group.FinalProject.name
}

# Create a subnet
resource "azurerm_subnet" "subnet-tf" {
  name                 = "tf-subnet"
  resource_group_name  = azurerm_resource_group.FinalProject.name
  virtual_network_name = azurerm_virtual_network.vmtf.name
  address_prefixes     = ["192.168.3.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "publiciptf" {
  name                = "public-pip"
  location            = azurerm_resource_group.FinalProject.location
  resource_group_name = azurerm_resource_group.FinalProject.name 
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "tf-nic" {
  name                = "tf-nic"
  location            = azurerm_resource_group.FinalProject.location
  resource_group_name = azurerm_resource_group.FinalProject.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-tf.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publiciptf.id
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm_tf" {
  name                = "tf-vm"
  resource_group_name = azurerm_resource_group.FinalProject.name
  location            = azurerm_resource_group.FinalProject.location
  size                = "Standard_DS1_v2"
 

  admin_username      = "adminuser"
  admin_password      = "Kigali@123!?"
  

  network_interface_ids = [
    azurerm_network_interface.tf-nic.id,
  ]

 admin_ssh_key {
        username = "adminuser"
        public_key = file("C:/Users/Sajini/azureuser.pub")
    
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


}
