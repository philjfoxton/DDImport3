locals {
  cluster_name = "pfm-prod-cluster"
  subnets      = data.terraform_remote_state.prod_vpc.outputs.private_subnets

  cluster_tags = {
    Terraform   = "true"
    Environment = "prod"
  }
  cluster_version = "1.15"


  default_eks_workers_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]

  workers_group = {
    instance_type = "m5.large"

    asg_max_size         = 5
    asg_min_size         = 1
    asg_desired_capacity = 1

    iam_instance_profile_name = aws_iam_instance_profile.workers.name

    enable_monitoring = false

    autoscaling_enabled = true
  }


}