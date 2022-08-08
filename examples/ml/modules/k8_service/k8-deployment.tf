resource "kubernetes_deployment" "local" {
  provider = kubernetes.local

  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.local.metadata[0].name

    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.k8_deployment_spec_replicas

    strategy {
      type = var.k8_deployment_spec_strategy_type
    }

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    progress_deadline_seconds = var.k8_deployment_spec_progress_deadline_seconds

    template {
      metadata {
        namespace = kubernetes_namespace.local.metadata[0].name
        labels = {
          app = var.app_name
        }

        annotations = {
          # Full DD integradion doc:
          # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
          "ad.datadoghq.com/state-metrics.check_names"  = jsonencode(["kubernetes_state"])
          "ad.datadoghq.com/state-metrics.init_configs" = "[{}]"
          "ad.datadoghq.com/state-metrics.instances" = jsonencode([{
            kube_state_url          = var.k8_deployment_spec_template_metadata_kube_state_url
            prometheus_timeout      = var.k8_deployment_spec_template_metadata_prometheus_timeout
            min_collection_interval = var.k8_deployment_spec_template_metadata_min_collection_interval
            telemetry               = var.k8_deployment_spec_template_metadata_telemetry
            label_joins = {
              kube_deployment_labels = {
                labels_to_match = ["deployment"]
                labels_to_get = [
                  "label_app",
                  "label_deploy_env",
                  "label_type",
                  "label_magic_net",
                  "label_canary",
                ]
              }
            }
            labels_mapper = {
              # We rename following labels because app and deploy_env are our "well known labels"
              label_app        = var.app_name
              label_deploy_env = var.env
            }
          }])
        }
      }

      spec {
        enable_service_links            = var.k8_deployment_spec_enable_service_links
        service_account_name            = kubernetes_manifest.local_sa.manifest.metadata.name
        automount_service_account_token = var.k8_deployment_spec_automount_service_account_token

        host_network = var.k8_deployment_spec_host_network

        container {
          # docker run --rm -it k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8 --help
          image                    = var.k8_deployment_spec_container_image
          image_pull_policy        = var.k8_deployment_spec_container_image_pull_policy
          name                     = var.app_name
          termination_message_path = var.k8_deployment_spec_container_termination_message_path
          command = [
            var.k8_deployment_spec_container_command,
          ]

          readiness_probe {
            http_get {
              path = var.k8_deployment_spec_container_readiness_probe_http_get_path
              port = var.k8_deployment_spec_container_readiness_probe_http_get_port
            }

            initial_delay_seconds = var.k8_deployment_spec_container_readiness_probe_initial_delay_seconds
            timeout_seconds       = var.k8_deployment_spec_container_readiness_probe_timeout_seconds
          }

          resources {
            requests = {
              cpu    = var.k8_deployment_spec_container_resources_requests_cpu
              memory = var.k8_deployment_spec_container_resources_requests_memory
            }

            limits = {
              cpu    = var.k8_deployment_spec_container_resources_limits_cpu
              memory = var.k8_deployment_spec_container_resources_limits_memory
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.local,
  ]
}