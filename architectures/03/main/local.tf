locals {
  # general
  prefix = "test"

  # front door
  frontdoor_cdn_priority             = 1
  frontdoor_cdn_weight               = 1
  additional_latency_in_milliseconds = 0
  health_probe_interval_in_seconds   = 60
  response_timeout_seconds           = 60
}
