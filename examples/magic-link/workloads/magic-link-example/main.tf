
module "k8_service" {
  source = "../../modules/k8_service"

  #vars
  k8_service_token = "state-metrics-token"

  k8_manifest_metadata_name                         = "state-metrics"
  k8_manifest_automountServiceAccountToken          = "false"
  k8_manifest_metadata_labels_app                   = "state-metrics"
  k8_manifest_kind                                  = "ServiceAccount"

  k8_cluster_role_metadata_name        = "state-metrics"
  k8_cluster_role_metadata_labels_app  = "state-metrics"

  k8_cluster_role_binding_metadata = "state-metrics-binding"
  k8_cluster_role_binding_labels_app = "state-metrics"
}