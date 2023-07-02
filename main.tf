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


#Creating our app service plan
resource "azurerm_service_plan" "plan" {
  name                = "Julplan"
  location            = azurerm_resource_group.Julrg.location
  resource_group_name = azurerm_resource_group.Julrg.name
  os_type             = "Windows"
  sku_name            = "B1"


}

#Creating our app service
resource "azurerm_windows_web_app" "plan" {
  name                = "Jul97app"
  location            = azurerm_resource_group.Julrg.location
  resource_group_name = azurerm_resource_group.Julrg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}

}

#Creating the public frontend ip for appgw
resource "azurerm_public_ip" "apip" {
  name                = "appgw-pip"
  resource_group_name = azurerm_resource_group.Julrg.name
  location            = azurerm_resource_group.Julrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creating the application gateway
resource "azurerm_application_gateway" "network" {
  name                = "Jul-appgw"
  resource_group_name = azurerm_resource_group.Julrg.name
  location            = azurerm_resource_group.Julrg.location
  firewall_policy_id    = azurerm_web_application_firewall_policy.app_policy.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.net1.id
  }



  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.apip.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = ["Jul97app.azurewebsites.net"]
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"

  }
}

#Creating our WAF policy to manage our firewall rules
resource "azurerm_web_application_firewall_policy" "app_policy" {
  name                = "app_policy"
  resource_group_name = azurerm_resource_group.Julrg.name
  location            = azurerm_resource_group.Julrg.location

  policy_settings {
    enabled                     = true
    mode                        = "Detection"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"

    }
  }
}