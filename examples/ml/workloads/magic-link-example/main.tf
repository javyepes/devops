
module "k8_service" {
  app_name     = "state-metrics"
  env          = "dev"
  k8_namespace = "mon"

  k8_deployment_spec_container_image                    = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"
  k8_deployment_spec_container_image_pull_policy        = "IfNotPresent"
  k8_deployment_spec_container_termination_message_path = "/dev/termination-log"
  k8_deployment_spec_container_command                  = "/kube-state-metrics --port=18080 --telemetry-port=18081"

  source = "../../modules/k8_service"

  #vars
  k8_service_token = "state-metrics-token"

  k8_manifest_automountServiceAccountToken          = "false"
  k8_manifest_kind                                  = "ServiceAccount"

  k8_cluster_role_binding_metadata = "state-metrics-binding"
}