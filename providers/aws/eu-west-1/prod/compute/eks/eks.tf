module "prod_eks" {
  source                 = "terraform-aws-modules/eks/aws"
  version                = "10.0.0"
  cluster_name           = local.cluster_name
  subnets                = local.subnets
  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_version        = local.cluster_version
  cluster_create_timeout = "60m"
  cluster_delete_timeout = "60m"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_log_retention_in_days = 30
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  manage_worker_iam_resources = false
  enable_irsa                 = true
  worker_groups = concat(
    [
      for subnet in local.subnets :
      merge(
        local.workers_group,
        {
          "name"    = "workers-${index(local.subnets, subnet)}",
          "subnets" = [subnet]
        }
      )
    ],
  )

  map_users = [
    {
      userarn  = "arn:aws:iam::881792143615:user/maksym.kryva"
      username = "maksym.kryva"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::881792143615:user/Andrey"
      username = "Andrey"
      groups   = ["system:masters"]
    },
  ]
  map_roles = [
    {
      rolearn  = data.terraform_remote_state.gitlab.outputs.gitlab_runner_role_arn
      username = data.terraform_remote_state.gitlab.outputs.gitlab_runner_role_name
      groups   = ["system:masters"]
    },
  ]


  worker_sg_ingress_from_port = "0"

  write_kubeconfig = false
  manage_aws_auth  = true

  worker_ami_name_filter = "amazon-eks-node-1.15-v20200312"
  tags                   = local.cluster_tags
}