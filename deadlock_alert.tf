resource "azurerm_monitor_metric_alert" "example" {
  name                = "deadlock-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_server.example.id]

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "deadlock"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}