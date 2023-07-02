# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.net1.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.net1.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.net1.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.net1.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.net1.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.net1.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.net1.name}-rdrcfg"
}


