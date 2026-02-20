resource "azurerm_container_app_environment" "default" {
  name                  = "${var.prefix}-acaenv"
  location              = var.resource_group_default_location
  resource_group_name   = var.resource_group_default_name
  public_network_access = "Enabled"
}

resource "azurerm_container_app" "default" {
  name                         = "${var.prefix}-capp"
  resource_group_name          = var.resource_group_default_name
  container_app_environment_id = azurerm_container_app_environment.default.id

  revision_mode = "Multiple"

  template {
    container {
      name   = "${var.prefix}app"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = var.capps_cpu
      memory = var.capps_memory
    }

    min_replicas = var.capps_min_replicas
    max_replicas = var.capps_max_replicas

    http_scale_rule {
      name                = "${var.prefix}-scale-rule"
      concurrent_requests = var.capps_scale_concurrent_requests
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
