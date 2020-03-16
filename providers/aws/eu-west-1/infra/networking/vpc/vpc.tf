module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "2.29.0"
  name                   = "PFM-Infra-VPC"
  cidr                   = local.vpc_cidr
  azs                    = local.vpc_azs
  private_subnets        = local.vpc_private_subnets
  public_subnets         = local.vpc_public_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_s3_endpoint     = true

  private_subnet_tags = {
    SubnetType = "Private"
  }

  public_subnet_tags = {
    SubnetType = "Public"
  }

  tags = {
    Terraform   = "true"
    Environment = "infra"
  }
}


