data "template_file" "client_userdata_script" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cloud_provider         = "aws"
    elasticsearch_data_dir = "/var/lib/elasticsearch"
    elasticsearch_logs_dir = local.elasticsearch_logs_dir
    heap_size              = local.client_heap_size
    es_cluster             = local.es_cluster
    security_groups        = aws_security_group.elasticsearch_security_group.id
    availability_zones     = join(",", local.availability_zones)
    master                 = "false"
    data                   = "false"
    bootstrap_node         = "false"
    aws_region             = var.aws_region
    security_enabled       = "false"
    monitoring_enabled     = "false"
    masters_count          = local.masters_count
    client_user            = ""
    client_pwd             = ""
    xpack_monitoring_host  = local.xpack_monitoring_host
    minimum_master_nodes   = local.masters_count
    security_enabled       = local.security_enabled
    monitoring_enabled     = local.monitoring_enabled
    device_name            = local.device_name
  }
}

resource "aws_launch_configuration" "client" {
  name_prefix                 = "elasticsearch-${local.es_cluster}-client-nodes"
  image_id                    = data.aws_ami.elasticsearch.id
  instance_type               = local.client_instance_type
  security_groups             = [aws_security_group.elasticsearch_security_group.id, aws_security_group.elasticsearch_clients_security_group.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.elasticsearch.id
  user_data                   = data.template_file.client_userdata_script.rendered

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20" # GB
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "client_nodes" {
  // Only create if it's not a single-node configuration
  count = local.masters_count == "0" && local.datas_count == "0" ? "0" : "1"

  name                 = "elasticsearch-${local.es_cluster}-client-nodes"
  max_size             = local.clients_count
  min_size             = local.clients_count
  desired_capacity     = local.clients_count
  default_cooldown     = 30
  force_delete         = true
  launch_configuration = aws_launch_configuration.client.id
  health_check_type    = local.health_check_type

  load_balancers = [aws_elb.es_client_lb.id]

  vpc_zone_identifier = local.clients_subnet_ids

  tag {
    key                 = "Name"
    value               = format("%s-client-node", local.es_cluster)
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = local.es_cluster
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "client"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}