resource "azurerm_monitor_action_group" "example" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "exampleactiongroup"

  email_receiver {
    name          = "sendtoadmin"
    email_address = "admin@example.com"
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metricalert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_application_insights_web_test.example.id]
  description         = "Action will be triggered when the condition is met"
  severity            = 4
  frequency           = "PT1M"
  window_size         = "PT5M"
  target_resource_type = "microsoft.insights/webtests"

  criteria {
    metric_namespace = "microsoft.insights/webtests"
    metric_name      = "synthetictransaction/availability"
    aggregation      = "Average"
    operator         = "Equals"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}
