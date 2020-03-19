resource "kubernetes_service_account" "kibana_es_logs" {
  metadata {
    name      = "kibana-es-logs"
    namespace = kubernetes_namespace.observability.metadata.0.name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "kibana_es_logs" {
  metadata {
    name = "kibana-es-logs"
    labels = {
      app = kubernetes_service_account.kibana_es_logs.metadata.0.name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["extensions", "apps", "networking"]
    resources  = ["*"]
    verbs      = ["*"]
  }

}
resource "kubernetes_cluster_role_binding" "kibana_es_logs" {
  metadata {
    name = kubernetes_service_account.kibana_es_logs.metadata.0.name
    labels = {
      app = kubernetes_service_account.kibana_es_logs.metadata.0.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kibana_es_logs.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kibana_es_logs.metadata.0.name
    namespace = kubernetes_namespace.observability.metadata.0.name
  }
}

data "template_file" "kibana_es_logs_values" {
  template = file("${path.module}/values/kibana.yaml")

  vars = {

    serviceAccountName = kubernetes_service_account.kibana_es_logs.metadata.0.name
  }
}

resource "helm_release" "kibana_es_logs" {
  name       = "kibana-es-logs"
  repository = data.helm_repository.elastic.metadata.0.name
  chart      = "kibana"
  version    = local.kibana_es_logs_helm_version
  namespace  = kubernetes_namespace.observability.metadata.0.name

  values = [
    data.template_file.kibana_es_logs_values.rendered
  ]
}
