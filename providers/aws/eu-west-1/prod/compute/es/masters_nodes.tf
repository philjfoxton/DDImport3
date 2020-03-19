data "template_file" "master_userdata_script" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cloud_provider         = "aws"
    elasticsearch_data_dir = "/var/lib/elasticsearch"
    elasticsearch_logs_dir = local.elasticsearch_logs_dir
    heap_size              = local.master_heap_size
    es_cluster             = local.es_cluster
    security_groups        = aws_security_group.elasticsearch_security_group.id
    availability_zones     = join(",", local.availability_zones)
    master                 = "true"
    data                   = "false"
    bootstrap_node         = "false"
    aws_region             = var.aws_region
    security_enabled       = local.security_enabled
    monitoring_enabled     = local.monitoring_enabled
    masters_count          = local.masters_count
    client_user            = ""
    client_pwd             = ""
    xpack_monitoring_host  = local.xpack_monitoring_host
    minimum_master_nodes   = local.masters_count
    device_name            = local.device_name
  }
}

resource "aws_launch_configuration" "master" {
  name_prefix                 = "elasticsearch-${local.es_cluster}-master-nodes"
  image_id                    = data.aws_ami.elasticsearch.id
  instance_type               = local.master_instance_type
  security_groups             = list(aws_security_group.elasticsearch_security_group.id)
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.elasticsearch.id
  user_data                   = data.template_file.master_userdata_script.rendered
  key_name                    = "infra"

  ebs_block_device {
    volume_type = "gp2"
    device_name = "/dev/xvdh"
    volume_size = "30" # GB
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30" # GB
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "master_nodes" {
  name                 = "elasticsearch-${local.es_cluster}-master-nodes"
  max_size             = local.masters_count
  min_size             = local.masters_count
  desired_capacity     = local.masters_count
  default_cooldown     = 30
  force_delete         = true
  launch_configuration = aws_launch_configuration.master.id

  vpc_zone_identifier = local.cluster_subnet_ids

  tag {
    key                 = "Name"
    value               = format("%s-master-node", local.es_cluster)
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = local.es_cluster
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "master"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
