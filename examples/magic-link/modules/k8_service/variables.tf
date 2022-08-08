variable "k8_service_token" {
  description = "k8 service token"
  type        = string
}

variable "k8_manifest_metadata_name" {
  description = ""
  type        = string
}

variable "k8_manifest_automountServiceAccountToken" {
  description = ""
  type        = string
}

variable "k8_manifest_metadata_labels_app" {
  description = ""
  type        = string
}

variable "k8_manifest_kind" {
  description = ""
  type        = string
}

variable "k8_cluster_role_metadata_name" {
  description = ""
  type = string
}

variable "k8_cluster_role_metadata_labels_app" {
  description = ""
  type        = string
}

variable "k8_cluster_role_binding_metadata" {
  description = ""
  type        = string
}

variable "k8_cluster_role_binding_labels_app" {
  description = ""
  type        = string
}
