

resource "kubernetes_cluster_role_binding" "local" {
  provider = kubernetes.local

  metadata {
    name = var.k8_cluster_role_binding_metadata

    labels = {
      app = var.app_name
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
    namespace = kubernetes_namespace.local.metadata[0].name
    api_group = ""
  }
}
