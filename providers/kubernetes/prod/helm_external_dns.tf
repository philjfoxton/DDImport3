data "template_file" "external_dns_values" {
  template = file("${path.module}/values/external_dns.yaml.tpl")

  vars = {
    role = data.terraform_remote_state.iam.outputs.external_dns_role
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "external-dns"
  version    = local.external_dns_helm_version
  namespace  = "kube-system"

  values = [
    data.template_file.external_dns_values.rendered
  ]
}