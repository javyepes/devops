



resource "kubernetes_cluster_role_binding" "local" {
  provider = kubernetes.local

  metadata {
    name = var.k8_cluster_role_binding_metadata

    labels = {
      app = var.k8_cluster_role_binding_labels_app
    }
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.local.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_manifest.local_sa.manifest.metadata.name
    namespace = kubernetes_namespace.mon_local.metadata[0].name
    api_group = ""
  }
}

resource "kubernetes_deployment" "local" {
  provider = kubernetes.local

  metadata {
    name      = "state-metrics"
    namespace = kubernetes_namespace.mon_local.metadata[0].name

    labels = {
      app = "state-metrics"
    }
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "state-metrics"
      }
    }

    progress_deadline_seconds = 180

    template {
      metadata {
        namespace = kubernetes_namespace.mon_local.metadata[0].name
        labels = {
          app = "state-metrics"
        }

        annotations = {
          # Full DD integradion doc:
          # https://github.com/DataDog/integrations-core/blob/master/kubernetes_state/datadog_checks/kubernetes_state/data/conf.yaml.example
          "ad.datadoghq.com/state-metrics.check_names"  = jsonencode(["kubernetes_state"])
          "ad.datadoghq.com/state-metrics.init_configs" = "[{}]"
          "ad.datadoghq.com/state-metrics.instances" = jsonencode([{
            kube_state_url          = "http://%%host%%:18080/metrics"
            prometheus_timeout      = 30
            min_collection_interval = 30
            telemetry               = true
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
              label_app        = "app"
              label_deploy_env = "deploy_env"
            }
          }])
        }
      }

      spec {
        enable_service_links            = false
        service_account_name            = kubernetes_manifest.local_sa.manifest.metadata.name
        automount_service_account_token = true

        host_network = true

        container {
          # docker run --rm -it k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8 --help
          image                    = "k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8"
          image_pull_policy        = "IfNotPresent"
          name                     = "state-metrics"
          termination_message_path = "/dev/termination-log"
          command = [
            "/kube-state-metrics",
            "--port=18080",
            "--telemetry-port=18081",
          ]

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "18080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          resources {
            requests = {
              cpu    = "30m"
              memory = "30Mi"
            }

            limits = {
              cpu    = "60m"
              memory = "50Mi"
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