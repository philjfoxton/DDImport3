module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "2.29.0"
  name                   = "pfm-production-vpc"
  cidr                   = local.vpc_cidr
  azs                    = local.vpc_azs
  private_subnets        = local.vpc_private_subnets
  public_subnets         = local.vpc_public_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_s3_endpoint     = true

  private_subnet_tags = {
    SubnetType                                        = "Private"
    "kubernetes.io/cluster/${local.pfm_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }

  public_subnet_tags = {
    SubnetType                                        = "Public"
    "kubernetes.io/cluster/${local.pfm_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  tags = {
    Terraform                                                 = "true"
    Environment                                               = "production"
    "kubernetes.io/cluster/${local.pfm_cluster_name}"         = "shared"
  }
}