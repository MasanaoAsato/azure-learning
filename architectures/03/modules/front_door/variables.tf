variable "resource_group_default_name" {
  description = "The name of the resource group default"
  type        = string
}

variable "prefix" {
  description = "prefix for resource name"
  type        = string

  default = "test"
}

variable "storage_primary_web_host" {
  description = "The hostname of the storage account static website"
  type        = string
}

variable "frontdoor_cdn_priority" {
  description = "The priority of the Front Door CDN origin"
  type        = number

  default = 1
}

variable "frontdoor_cdn_weight" {
  description = "The weight of the Front Door CDN origin"
  type        = number

  default = 1
}

variable "additional_latency_in_milliseconds" {
  description = "The additional latency in milliseconds for the Front Door CDN origin"
  type        = number

  default = 0
}

variable "health_probe_interval_in_seconds" {
  description = "The interval in seconds for the health probe"
  type        = number

  default = 60
}

variable "response_timeout_seconds" {
  description = "The response timeout in seconds for the Front Door CDN profile"
  type        = number

  default = 60
}
