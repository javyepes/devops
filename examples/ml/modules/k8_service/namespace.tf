resource "kubernetes_namespace" "local" {
  provider = kubernetes.local

  metadata {
    name = var.k8_namespace
  }
}
