resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = "gitlab"
  }
}

resource "kubernetes_service_account" "gitlab" {
  metadata {
    name      = "gitlab-runner"
    namespace = kubernetes_namespace.gitlab.metadata.0.name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "gitlab" {
  metadata {
    name = "gitlab-runner"
    labels = {
      app = kubernetes_service_account.gitlab.metadata.0.name
    }
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}
resource "kubernetes_cluster_role_binding" "gitlab" {
  metadata {
    name = kubernetes_service_account.gitlab.metadata.0.name
    labels = {
      app = kubernetes_service_account.gitlab.metadata.0.name
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.gitlab.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.gitlab.metadata.0.name
    namespace = kubernetes_namespace.gitlab.metadata.0.name
  }
}



data "template_file" "gitlab_runner_values" {
  template = file("${path.module}/values/gitlab-runner.yaml.tpl")

  vars = {
    registration_token = data.aws_kms_secrets.gitlab_token.plaintext["gitlab"]
    serviceAccountName = kubernetes_service_account.gitlab.metadata.0.name
  }
}



resource "helm_release" "gitlab_runner" {
  name       = "gitlab-runner"
  repository = data.helm_repository.gitlab.metadata.0.name
  chart      = "gitlab-runner"
  version    = local.gitlab_runner_helm_version
  namespace  = kubernetes_namespace.gitlab.metadata.0.name

  values = [
    data.template_file.gitlab_runner_values.rendered
  ]
}
