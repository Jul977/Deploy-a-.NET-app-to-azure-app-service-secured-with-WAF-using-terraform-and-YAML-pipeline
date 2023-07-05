terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Instructing terraform to use the remote backend for our state file
# Comment this block of code if a remote backend is not configured
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-rg-statefile"
    storage_account_name = "jultfstorage"
    container_name       = "jultfstate"
    key                  = "app.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

#Creating our resource group
resource "azurerm_resource_group" "Julrg" {
  name     = "JulRg"
  location = "East Us"
  tags = {
    environment = "dev"
  }
}

#Creating our virtual network
resource "azurerm_virtual_network" "net1" {
  name                = "Hub-vnet"
  location            = azurerm_resource_group.Julrg.location
  resource_group_name = azurerm_resource_group.Julrg.name
  address_space       = ["10.10.0.0/16"]
  tags = {
    environment = "dev"
  }

}

#Creating our app gw subnet
resource "azurerm_subnet" "net1" {
  name                 = "appgwsubnet"
  resource_group_name  = azurerm_resource_group.Julrg.name
  virtual_network_name = azurerm_virtual_network.net1.name
  address_prefixes     = ["10.10.1.0/24"]
}

#Creating the public ip for appgw
resource "azurerm_public_ip" "apip" {
  name                = "appgw-pip"
  resource_group_name = azurerm_resource_group.Julrg.name
  location            = azurerm_resource_group.Julrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

