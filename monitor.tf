# Azure Monitorリソースプロバイダーを有効にするためのコード
provider "azurerm" {
  features {}
}

# Azure Log Analytics Workspaceを作成するためのコード
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-workspace"
  location            = "japaneast"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

# ログ分析クエリを作成するためのコード
resource "azurerm_monitor_log_query" "example" {
  name                = "example-log-query"
  workspace_id        = azurerm_log_analytics_workspace.example.id
  query               = "AzureDiagnostics | where Category == 'SQLSecurityAuditEvents' and audit_event_type_s == 'SQL_BATCH_COMPLETED' | project TimeGenerated, server_instance_name_s, database_name_s, client_ip_s, application_name_s, command_s, username_s | sort by TimeGenerated desc | limit 10"
  query_type          = "Result"
  result_format       = "Table"
  workspace_name      = azurerm_log_analytics_workspace.example.name
}

# アクショングループを作成するためのコード
resource "azurerm_monitor_action_group" "example" {
  name                = "example-action-group"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "example-action-group"
  email_receiver {
    name                 = "example"
    email_address        = "example@example.com"
    use_common_alert_schema = true
  }
}

# アラートルールを作成するためのコード
resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metric-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_database.example.id]
  description         = "Example Metric Alert Rule"
  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "successful_sql_auto_tuning_actions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1
    time_grain       = "PT5M"
    dimension {
      name     = "database_name"
      operator = "Include"
      values   = ["example_database"]
    }
  }
  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}
