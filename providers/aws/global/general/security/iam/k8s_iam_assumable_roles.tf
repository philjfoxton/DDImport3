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

module "auth_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "auth_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.auth_service_policy.arn
  ]
}


module "connections_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "connections_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.connections_service_policy.arn

  ]
}

module "goals_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "goals_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.goals_service_policy.arn

  ]
}

module "notifications_api" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "notifications_api"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.notifications_api_policy.arn

  ]
}

module "notifications_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "notifications_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.notifications_service_policy.arn

  ]
}

module "obpexporter_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "obpexporter_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.obpexporter_service_policy.arn

  ]
}

module "transactions_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "transactions_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
    module.transactions_service_policy.arn

  ]
}

module "statements_service" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "2.7.0"
  create_role  = true
  role_name    = "statements_service"
  provider_url = local.eks_oidc_provider
  role_policy_arns = [
  ]
}