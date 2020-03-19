output "pubic_certs" {
  value = {
    for cert in aws_acm_certificate.cert :
    replace(cert.domain_name, "/[.]$/", "") => cert.arn
  }
}
