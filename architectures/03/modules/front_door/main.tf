resource "azurerm_cdn_frontdoor_profile" "default" {
  name                     = "${var.prefix}-cdnprofile"
  resource_group_name      = var.resource_group_default_name
  sku_name                 = "Premium_AzureFrontDoor"
  response_timeout_seconds = var.response_timeout_seconds

  identity {
    type = "SystemAssigned"
  }

  log_scrubbing_rule {
    match_variable = "RequestIPAddress"
  }
}

resource "azurerm_cdn_frontdoor_firewall_policy" "default" {
  name                = "${var.prefix}wafpolicy"
  resource_group_name = var.resource_group_default_name
  sku_name            = "Premium_AzureFrontDoor"
  enabled             = true
  mode                = "Prevention"

  custom_rule {
    name                           = "RateLimitByIP"
    enabled                        = true
    priority                       = 1
    type                           = "RateLimitRule"
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 200
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["0.0.0.0/0", "::/0"]
    }
  }

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.1"
    action  = "Block"
  }
}

resource "random_string" "endpoint_suffix" {
  length  = 6
  lower   = true
  numeric = true
  special = false
  upper   = false
}

resource "azurerm_cdn_frontdoor_endpoint" "default" {
  name                     = "${var.prefix}-endpoint-${random_string.endpoint_suffix.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
}

resource "azurerm_cdn_frontdoor_security_policy" "default" {
  name                     = "${var.prefix}-security-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.default.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.default.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "default" {
  name                     = "${var.prefix}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
  session_affinity_enabled = true

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10

  health_probe {
    interval_in_seconds = var.health_probe_interval_in_seconds
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = var.additional_latency_in_milliseconds
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "default" {
  name                          = "${var.prefix}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name          = var.storage_primary_web_host
  http_port          = 80
  https_port         = 443
  origin_host_header = var.storage_primary_web_host
  priority           = var.frontdoor_cdn_priority
  weight             = var.frontdoor_cdn_weight
}

resource "azurerm_cdn_frontdoor_route" "default" {
  name                          = "${var.prefix}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.default.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.default.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  link_to_default_domain = true

  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/css", "application/javascript", "application/json", "image/svg+xml"]
  }
}
