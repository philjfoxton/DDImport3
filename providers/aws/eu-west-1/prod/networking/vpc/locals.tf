locals {
  vpc_azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_cidr            = "172.20.0.0/16"
  vpc_private_subnets = ["172.20.2.0/24", "172.20.3.0/24", "172.20.4.0/24"]
  vpc_public_subnets  = ["172.20.102.0/24", "172.20.103.0/24", "172.20.104.0/24"]
  pfm_cluster_name    = "pfm-prod-cluster"
}
