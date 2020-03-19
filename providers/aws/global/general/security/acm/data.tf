data "aws_route53_zone" "zones" {
  name         = local.public_certs[count.index].route53_zone_name
  private_zone = false
  count        = length(local.public_certs)
}