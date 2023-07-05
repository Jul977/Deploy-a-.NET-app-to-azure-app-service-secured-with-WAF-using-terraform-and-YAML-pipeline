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