variable "k8_service_token" {
  description = "k8 service token"
  type        = string
}

## Manifest vars
variable "k8_manifest_automountServiceAccountToken" {
  description = ""
  type        = string
}

variable "k8_manifest_kind" {
  description = ""
  type        = string
}
## cluster role vars
variable "k8_cluster_role_binding_metadata" {
  description = ""
  type        = string
}
## deployment vars
variable "k8_deployment_spec_replicas" {
  description = ""
  type        = number
  default     = 1
}

variable "k8_deployment_spec_strategy_type" {
  description = ""
  type        = string
  default     = "Recreate"
}

variable "k8_deployment_spec_progress_deadline_seconds" {
  description = ""
  type        = number
  default     = 180
}

variable "k8_deployment_spec_template_metadata_kube_state_url" {
  description = ""
  type        = string
  default     = "http://%%host%%:18080/metrics"
}

variable "k8_deployment_spec_template_metadata_prometheus_timeout" {
  description = ""
  type        = number
  default     = 30
}

variable "k8_deployment_spec_template_metadata_min_collection_interval" {
  description = ""
  type        = string
  default     = 30
}

variable "k8_deployment_spec_template_metadata_telemetry" {
  description = ""
  type        = string
  default     = true
}
variable "k8_deployment_spec_enable_service_links" {
  description = ""
  type        = string
  default     = false
}

variable "k8_deployment_spec_automount_service_account_token" {
  description = ""
  type        = string
  default     = true
}

variable "k8_deployment_spec_host_network" {
  description = ""
  type        = string
  default     = true
}

variable "k8_deployment_spec_container_image" {
  description = ""
  type        = string
}

variable "k8_deployment_spec_container_image_pull_policy" {
  description = ""
  type        = string
}

variable "k8_deployment_spec_container_termination_message_path" {
  description = ""
  type        = string
}

variable "k8_deployment_spec_container_command" {
  description = ""
  type        = string
}

variable "k8_deployment_spec_container_readiness_probe_http_get_path" {
  description = ""
  type        = string
  default     = "/healthz"
}

variable "k8_deployment_spec_container_readiness_probe_http_get_port" {
  description = ""
  type        = number
  default     = 18080
}

variable "k8_deployment_spec_container_readiness_probe_initial_delay_seconds" {
  description = ""
  type        = number
  default     = 5
}

variable "k8_deployment_spec_container_readiness_probe_timeout_seconds" {
  description = ""
  type        = number
  default     = 5
}

variable "k8_deployment_spec_container_resources_requests_cpu" {
  description = ""
  type        = string
  default     = "30m"
}

variable "k8_deployment_spec_container_resources_requests_memory" {
  description = ""
  type        = string
  default     = "30mi"
}

variable "k8_deployment_spec_container_resources_limits_cpu" {
  description = ""
  type        = string
  default     = "60m"
}

variable "k8_deployment_spec_container_resources_limits_memory" {
  description = ""
  type        = string
  default     = "50mi"
}

##
variable "app_name" {
  description = "service or app name"
  type        = string
}

variable "env" {
  description = "env where the workload lives"
  type        = string
}

variable "k8_namespace" {
  description = ""
  type        = string
}
