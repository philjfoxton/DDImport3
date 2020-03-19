module "external_dns_role" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "external-dns"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.external_dns_policy.arn

  ]
}