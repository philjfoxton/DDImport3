output "internal_zones_ids" {
  value = {
    for zone in aws_route53_zone.internal_zone :
    replace(zone.name, "/[.]$/", "") => zone.zone_id
  }
}

output "internal_zones_names" {
  value = {
    for zone in aws_route53_zone.internal_zone :
    replace(zone.name, "/[.]$/", "") => replace(zone.name, "/[.]$/", "")
  }
}

