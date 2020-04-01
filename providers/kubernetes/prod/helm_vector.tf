resource "helm_release" "vector" {
  name      = "vector"
  chart     = "${path.module}/charts/vector"
  namespace = kubernetes_namespace.prod.metadata.0.name
  values = [
    file("${path.module}/values/vector.yaml")
  ]
}