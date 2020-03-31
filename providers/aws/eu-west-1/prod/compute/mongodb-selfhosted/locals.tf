locals {
  environment = "prod"
  service_name = "mongodb"
  device_name = "/dev/xvdh"
  volume_size = 100
  encrypted   = true
  mongodb_data_dir = "/opt/mongodb/data"
  instance_count = 3
  route53_zone   = data.terraform_remote_state.route53.outputs.internal_zones_ids["prod.pfm.internal"]

}