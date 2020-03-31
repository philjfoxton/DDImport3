output "instances" {
  value = module.mongodb.id
}

output "instance_ips" {
  value = module.mongodb.private_ip
}

output "route53" {
  value = aws_route53_record.mongodb.*.fqdn
}