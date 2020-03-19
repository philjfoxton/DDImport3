locals {
  ami_version = "0.1.8"

  route53_zone   = data.terraform_remote_state.route53.outputs.internal_zones_ids["prod.pfm.internal"]

  es_cluster         = "pfm-prod-es"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  availability_zones = data.terraform_remote_state.vpc.outputs.availability_zones
  clients_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  cluster_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  device_name        = "/dev/xvdh"

  data_instance_type        = "m5.large"
  master_instance_type      = "t3.small"
  elasticsearch_volume_size = "100" # gb
  volume_encryption         = true
  elasticsearch_data_dir    = "/opt/elasticsearch/data"
  elasticsearch_logs_dir    = "/var/log/elasticsearch"
  data_heap_size            = "4g"
  master_heap_size          = "1g"
  client_heap_size          = "4g"
  masters_count             = 3
  datas_count               = 3
  clients_count             = 2
  http_enabled              = "9200"
  security_enabled          = false
  monitoring_enabled        = true

  ebs_optimized = "true"

  lb_port = 80

  health_check_type = "EC2"

  xpack_monitoring_host = "self"

  # S3 bucket for backups
  s3_backup_bucket     = ""
  client_instance_type = "m5.large"
}

