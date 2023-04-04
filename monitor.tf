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

# sqlアラートルールを作成するためのコード
resource "azurerm_monitor_metric_alert" "sql_memory_alert" {
  name                = "sql-memory-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_database.example.id]
  description         = "This alert will trigger when the memory usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "buffer_pool_percent" # バッファプールのメモリ使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80 # 閾値を設定します（この例では80%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "DatabaseName"
      operator = "Include"
      values   = ["example-sql-database"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# SQL DB CPU使用率を監視するためのコード
resource "azurerm_monitor_metric_alert" "sql_cpu_alert" {
  name                = "sql-cpu-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_database.example.id]
  description         = "This alert will trigger when the CPU usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "cpu_percent" # CPU使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80 # 閾値を設定します（この例では80%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "DatabaseName"
      operator = "Include"
      values   = ["example-sql-database"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# Strage Accountの使用量を監視するためのコード
resource "azurerm_monitor_metric_alert" "storage_usage_alert" {
  name                = "example-storage-usage-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_storage_account.example.id]
  description         = "This alert will trigger when the storage usage exceeds 80% of the capacity."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0.8 * 1024 * 1024 * 1024 * 1024  # 80% of 1 TiB in bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# SQL DB DTU使用率を監視するためのコード
resource "azurerm_monitor_metric_alert" "sql_dtu_alert" {
  name                = "sql-dtu-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_database.example.id]
  description         = "This alert will trigger when the DTU usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "dtu_consumption_percent" # DTU使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80 # 閾値を設定します（この例では80%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "DatabaseName"
      operator = "Include"
      values   = ["example-sql-database"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# SQL DB ディスク使用率を監視するためのコード
resource "azurerm_monitor_metric_alert" "sql_disk_usage_alert" {
  name                = "sql-disk-usage-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_sql_database.example.id]
  description         = "This alert will trigger when the disk usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "storage_percent" # ディスク使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90 # 閾値を設定します（この例では90%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "DatabaseName"
      operator = "Include"
      values   = ["example-sql-database"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

# redisのアラートルールを作成するためのコード

resource "azurerm_monitor_metric_alert" "redis_cpu_alert" {
  name                = "redis-cpu-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_redis_cache.example.id]
  description         = "This alert will trigger when CPU usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Cache/Redis"
    metric_name      = "cacheprocessorpercent" # CPU使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 75 # 閾値を設定します（この例では75%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "CacheName"
      operator = "Include"
      values   = ["example-redis-cache"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

resource "azurerm_monitor_metric_alert" "redis_memory_alert" {
  name                = "redis-memory-alert"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_redis_cache.example.id]
  description         = "This alert will trigger when the memory usage percentage is greater than a certain threshold."

  criteria {
    metric_namespace = "Microsoft.Cache/Redis"
    metric_name      = "used_memory_percentage" # メモリ使用率のメトリック
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90 # 閾値を設定します（この例では90%としています）

    # 必要に応じて、次元フィルタリングを設定できます
    dimension {
      name     = "CacheName"
      operator = "Include"
      values   = ["example-redis-cache"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}
