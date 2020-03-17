locals {
  internal_root_zone_name = "pfm.internal"
  internal_zones          = ["prod.${local.internal_root_zone_name}"]
}