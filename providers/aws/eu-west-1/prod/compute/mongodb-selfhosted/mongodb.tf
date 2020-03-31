module "mongodb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  name        = local.service_name
  description = "Allow access to ${local.service_name}"

  vpc_id        = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]

  ingress_cidr_blocks = [
    data.terraform_remote_state.vpc.outputs.vpc_cidr,
  ]
}
data "template_file" "mongodb_userdata" {
  template = "./userdata.sh"
  vars = {
    mongodb_data_dir = local.mongodb_data_dir
  }
}


module "mongodb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.12.0"
  name                   = local.service_name
  instance_count         = local.instance_count
  ami                    = data.aws_ami.mongodb.id
  instance_type          = "t3.large"
  vpc_security_group_ids = [module.mongodb_sg.this_security_group_id]
  key_name               = "infra"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  associate_public_ip_address = false

  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 20
      delete_on_termination = false
    },
  ]
  ebs_optimized = true

  ebs_block_device = [
    {
      volume_type = "gp2"
      device_name = local.device_name
      volume_size = local.volume_size
      encrypted   = local.encrypted
    }
  ]
  user_data = data.template_file.mongodb_userdata.rendered
}

resource "aws_route53_record" "mongodb" {
  name    = "mongodb-${count.index}"
  type    = "A"
  records = [module.mongodb.private_ip[count.index]]
  zone_id = local.route53_zone
  ttl     = 30
  count   = local.instance_count
}