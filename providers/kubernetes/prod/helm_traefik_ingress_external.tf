resource "helm_release" "traefik_ingress_external" {
  name       = "traefik-ingress-external"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "traefik"
  version    = local.traefik_helm_version
  namespace  = "kube-system"

  values = [
    file("${path.module}/values/traefik_ingress_external.yaml")
  ]
}
