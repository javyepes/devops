resource "kubernetes_secret" "local_sa_token" {
  provider = kubernetes.local

  metadata {
    name      = var.k8_service_token
    namespace = kubernetes_namespace.mon_local.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_manifest.local_sa.manifest.metadata.name
    }
  }

  type = "kubernetes.io/service-account-token"
}