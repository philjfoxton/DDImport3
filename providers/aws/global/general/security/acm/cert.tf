resource "aws_acm_certificate" "cert" {
  domain_name       = local.public_certs[count.index].cert
  validation_method = "DNS"
  count             = length(local.public_certs)
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zones[count.index].zone_id
  records = [aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_value]
  ttl     = 60
  count   = length(local.public_certs)

}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert[count.index].arn
  validation_record_fqdns = [aws_route53_record.cert_validation[count.index].fqdn]
  count                   = length(local.public_certs)
}