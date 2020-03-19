resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}
data "template_file" "prometheus_values" {
  template = file("${path.module}/values/prometheus.yaml")

  vars = {
    grafana_password = "admin"
  }
}

resource "helm_release" "prometheus" {
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "prometheus-operator"
  name       = "prometheus"
  version    = local.prometheus_helm_version
  namespace  = kubernetes_namespace.observability.metadata.0.name

  values = [
    data.template_file.prometheus_values.rendered
  ]
}