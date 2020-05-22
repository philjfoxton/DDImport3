data "template_file" "alb-ingress_values" {
  template = file("${path.module}/values/alb-ingress.yaml.tpl")
  vars = {
    name = data.aws_eks_cluster.cluster.name
    role = data.terraform_remote_state.iam.outputs.alb_ingress_controller_role
  }
}



resource "helm_release" "alb-ingress" {
  repository = data.helm_repository.incubator.metadata.0.url
  chart      = "aws-alb-ingress-controller"
  name       = "aws-alb-ingress-controller"
  version    = local.alb-ingress_helm_version
  namespace  = "kube-system"
  values = [
    data.template_file.alb-ingress_values.rendered
  ]
}
