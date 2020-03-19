locals {
  public_certs = [
    {
      route53_zone_name = "tarabutgateway.net."
      cert              = "*.tarabutgateway.net"
      additional        = null
    }
  ]
}