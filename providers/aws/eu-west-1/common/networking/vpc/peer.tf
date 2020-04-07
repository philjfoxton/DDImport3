module "vpc-peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "2.1.0"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = module.vpc.vpc_id
  peer_vpc_id = local.unified

  auto_accept_peering = true

  tags = {
    Name        = "PFM2PROD"
    Environment = "Prod"
  }
}