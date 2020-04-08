resource "aws_route53_zone" "internal_zone" {
  name = local.internal_zones[count.index]

  vpc {
    vpc_id = data.terraform_remote_state.prod_vpc.outputs.vpc_id
  }
  vpc {
    vpc_id = local.unified
  }

  count = length(local.internal_zones)
}


