resource "kubernetes_manifest" "local_sa" {
  provider = kubernetes.local

  manifest = {
    apiVersion = "v1"
    kind       = var.k8_manifest_kind
    metadata = {
      namespace = kubernetes_namespace.local.metadata[0].name
      name      = var.app_name

      labels = {
        app = var.app_name
      }
    }

    automountServiceAccountToken = var.k8_manifest_automountServiceAccountToken
  }
}
