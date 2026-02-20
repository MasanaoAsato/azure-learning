locals {
  # general
  prefix = "test"

  # container apps
  capps_cpu                       = 0.5
  capps_memory                    = "1Gi"
  capps_min_replicas              = 0
  capps_max_replicas              = 3
  capps_scale_concurrent_requests = 10
}
