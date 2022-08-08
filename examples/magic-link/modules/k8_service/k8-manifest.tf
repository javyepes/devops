resource "kubernetes_manifest" "local_sa" {
  provider = kubernetes.local

  manifest = {
    apiVersion = "v1"
    kind       = var.k8_manifest_kind
    metadata = {
      namespace = kubernetes_namespace.mon_local.metadata[0].name
      name      = var.k8_manifest_metadata_name

      labels = {
        app = var.k8_manifest_metadata_labels_app
      }
    }

    automountServiceAccountToken = var.k8_manifest_automountServiceAccountToken
  }
}
