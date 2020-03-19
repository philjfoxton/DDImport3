data "template_file" "data_userdata_script" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cloud_provider         = "aws"
    elasticsearch_data_dir = local.elasticsearch_data_dir
    elasticsearch_logs_dir = local.elasticsearch_logs_dir
    heap_size              = local.data_heap_size
    es_cluster             = local.es_cluster
    security_groups        = aws_security_group.elasticsearch_security_group.id
    availability_zones     = join(",", local.availability_zones)
    master                 = "false"
    data                   = "true"
    bootstrap_node         = "false"
    ingest                 = "true"
    aws_region             = var.aws_region
    masters_count          = local.masters_count
    client_user            = ""
    client_pwd             = ""
    device_name            = local.device_name
    security_enabled       = local.security_enabled
    monitoring_enabled     = local.monitoring_enabled
    xpack_monitoring_host  = local.xpack_monitoring_host
    minimum_master_nodes   = 2
  }
}

resource "aws_launch_configuration" "data" {
  name_prefix                 = "elasticsearch-${local.es_cluster}-data-nodes"
  image_id                    = data.aws_ami.elasticsearch.id
  instance_type               = local.data_instance_type
  security_groups             = [aws_security_group.elasticsearch_security_group.id]
  key_name                    = "infra"
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.elasticsearch.id
  user_data                   = data.template_file.data_userdata_script.rendered

  ebs_optimized = local.ebs_optimized

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }

  ebs_block_device {
    volume_type = "gp2"
    device_name = local.device_name
    volume_size = local.elasticsearch_volume_size
    encrypted   = local.volume_encryption
  }
}

resource "aws_autoscaling_group" "data_nodes" {
  name                 = "elasticsearch-${local.es_cluster}-data-nodes"
  max_size             = local.datas_count
  min_size             = local.datas_count
  desired_capacity     = local.datas_count
  default_cooldown     = 30
  force_delete         = true
  launch_configuration = aws_launch_configuration.data.id

  vpc_zone_identifier = local.cluster_subnet_ids

  depends_on = [aws_autoscaling_group.master_nodes]

  tag {
    key                 = "Name"
    value               = format("%s-data-node", local.es_cluster)
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = local.es_cluster
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "data"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

