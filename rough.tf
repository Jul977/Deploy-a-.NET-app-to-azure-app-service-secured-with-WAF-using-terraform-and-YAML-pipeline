/*resource "azurerm_route_table" "route_table" {
  for_each            = var.rt_name
  name                = each.value.rt
  location            = azurerm_resource_group.Julrg.location
  resource_group_name = azurerm_resource_group.Julrg.name

  route {
    name                   = each.value.rtn
    address_prefix         = each.value.addr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.3.4"
  }
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each       = var.rt_name
  subnet_id      = local.subnet_ids[each.value.snetid]
  route_table_id = azurerm_route_table.route_table[each.key].id
}


variable "rt_name" {
  type = map(object({
    rt     = string
    rtn    = string
    addr   = string
    snetid = string

  }))
  default = {
    "rt1" = {
      rt     = "appgw_rt"
      rtn    = "appgw-appservice"
      addr   = "10.10.2.0/24"
      snetid = "net1"
    }

    "rt2" = {
      rt     = "appservice_rt"
      rtn    = "appservice-appgw"
      addr   = "10.10.1.0/24"
      snetid = "net2"
    }
    "rt3" = {
      rt     = "appservice_rt"
      rtn    = "appservice-fw"
      addr   = "0.0.0.0/0"
      snetid = "net2"
    }
  }
}

locals {
  subnet_ids = {
    "net1" = azurerm_subnet.net1.id
    "net2" = azurerm_subnet.net2.id
  }
}
*/
