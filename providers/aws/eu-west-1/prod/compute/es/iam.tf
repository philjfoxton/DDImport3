data "template_file" "data_s3_backup" {
  template = file("${path.module}/templates/s3-backup.json")

  vars = {
    s3_backup_bucket = local.s3_backup_bucket
  }
}

data "template_file" "data_asg_describe" {
  template = file("${path.module}/templates/asg-describe.json")
}

resource "aws_iam_role" "elasticsearch" {
  name               = "${local.es_cluster}-elasticsearch-discovery-role"
  assume_role_policy = file("${path.module}/templates/ec2-role-trust-policy.json")
}

resource "aws_iam_role_policy" "elasticsearch" {
  name = "${local.es_cluster}-elasticsearch-discovery-policy"
  policy = file(
    "${path.module}/templates/ec2-allow-describe-instances.json",
  )
  role = aws_iam_role.elasticsearch.id
}

resource "aws_iam_role_policy" "asg_discover" {
  count  = local.masters_count != "0" ? 1 : 0
  name   = "${local.es_cluster}-elasticsearch-asg-discover-policy"
  policy = data.template_file.data_asg_describe.rendered
  role   = aws_iam_role.elasticsearch.id
}

resource "aws_iam_role_policy" "s3_backup" {
  count  = local.s3_backup_bucket != "" ? 1 : 0
  name   = "${local.es_cluster}-elasticsearch-backup-policy"
  policy = data.template_file.data_s3_backup.rendered
  role   = aws_iam_role.elasticsearch.id
}

resource "aws_iam_instance_profile" "elasticsearch" {
  name = "${local.es_cluster}-elasticsearch-discovery-profile"
  path = "/"
  role = aws_iam_role.elasticsearch.name
}

