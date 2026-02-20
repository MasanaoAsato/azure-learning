variable "resource_group_default_location" {
  description = "The location of the resource group default"
  type        = string
}

variable "resource_group_default_name" {
  description = "The name of the resource group default"
  type        = string
}

variable "prefix" {
  description = "prefix for resource name"
  type        = string

  default = "test"
}

variable "capps_cpu" {
  description = "CPU for container apps"
  type        = number
  default     = 0.5
}

variable "capps_memory" {
  description = "Memory for container apps"
  type        = string
  default     = "0.5Gi"
}

variable "capps_min_replicas" {
  description = "Minimum number of replicas for container apps"
  type        = number
  default     = 0
}

variable "capps_max_replicas" {
  description = "Maximum number of replicas for container apps"
  type        = number
  default     = 3
}

variable "capps_scale_concurrent_requests" {
  description = "Concurrent requests for container apps scale rule"
  type        = number
  default     = 10
}
