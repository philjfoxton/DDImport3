data "local_file" "cluster_bootstrap_state" {
  filename = "${path.module}/cluster_bootstrap_state"
}


data "template_file" "bootstrap_userdata_script" {
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
    bootstrap_node         = "true"
    aws_region             = var.aws_region
    masters_count          = local.masters_count
    client_user            = ""
    client_pwd             = ""
    device_name            = local.device_name
    security_enabled       = local.security_enabled
    monitoring_enabled     = local.monitoring_enabled
    xpack_monitoring_host  = local.xpack_monitoring_host
    minimum_master_nodes   = 3
  }
}



resource "aws_instance" "bootstrap_node" {
  ami                                  = data.aws_ami.elasticsearch.id
  instance_type                        = local.master_instance_type
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [
    aws_security_group.elasticsearch_security_group.id,
  ]
  iam_instance_profile = aws_iam_instance_profile.elasticsearch.id
  user_data            = data.template_file.bootstrap_userdata_script.rendered
  subnet_id            = local.cluster_subnet_ids[0]
  key_name             = "infra"
  tags = {
    Name        = "${local.es_cluster}-bootstrap-node"
    Cluster     = local.es_cluster
    Role        = "bootstrap"
  }
}

resource "null_resource" "cluster_bootstrap_state" {
  provisioner "local-exec" {
    command = "printf 1 > ${path.module}/cluster_bootstrap_state"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "printf 0 > ${path.module}/cluster_bootstrap_state"
  }

  depends_on = [aws_instance.bootstrap_node]
}