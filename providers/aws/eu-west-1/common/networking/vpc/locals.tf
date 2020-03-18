locals {
  vpc_azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_cidr            = "10.11.0.0/16"
  vpc_private_subnets = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
  vpc_public_subnets  = ["10.11.101.0/24", "10.11.102.0/24", "10.11.103.0/24"]
  pfm_cluster_name    = "pfm-prod-cluster"
}
