module "prod_to_infra" {
  source  = "grem11n/vpc-peering/aws"
  version = "2.2.3"
  this_vpc_id          = module.vpc.vpc_id
  peer_vpc_id          = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  auto_accept_peering  = true
  tags = {
    Environment = "prod_infra"
  }

  providers = {
    aws.this = aws
    aws.peer = aws
  }
}