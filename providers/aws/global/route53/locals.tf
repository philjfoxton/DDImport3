locals {
  internal_root_zone_name = "pfm.internal"
  internal_zones          = ["prod.${local.internal_root_zone_name}"]
  unified                 = "vpc-05f9e904d9eb623e0"
}