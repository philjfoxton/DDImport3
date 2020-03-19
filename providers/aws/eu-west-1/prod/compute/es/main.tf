resource "aws_security_group" "elasticsearch_security_group" {
  name        = "elasticsearch-${local.es_cluster}-security-group"
  description = "Elasticsearch ports with ssh"
  vpc_id      = local.vpc_id

  tags = {
    Name    = "${local.es_cluster}-elasticsearch"
    cluster = local.es_cluster
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9400
    protocol    = "tcp"
    cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  # https
  ingress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  # allow inter-cluster ping
  ingress {
    from_port = 8
    to_port   = 0
    protocol  = "icmp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "elasticsearch_clients_security_group" {
  name   = "elasticsearch-${local.es_cluster}-clients-security-group"
  vpc_id = local.vpc_id

  tags = {
    Name    = "${local.es_cluster}-client"
    cluster = local.es_cluster
  }

  ingress {
    from_port   = 9200
    to_port     = 9400
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  # https
  ingress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_elb" "es_client_lb" {

  name                        = format("%s-client-lb", local.es_cluster)
  security_groups             = [aws_security_group.elasticsearch_clients_security_group.id]
  subnets                     = local.clients_subnet_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 120
  internal                    = true

  listener {
    instance_port      = 9200
    instance_protocol  = "http"
    lb_port            = local.lb_port
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:9200/_cluster/health"
    interval            = 6
  }

  tags = {
    Name = format("%s-client-lb", local.es_cluster)
  }
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = local.route53_zone
  name    = "es-logs"
  type    = "A"

  alias {
    name                   = aws_elb.es_client_lb.dns_name
    zone_id                = aws_elb.es_client_lb.zone_id
    evaluate_target_health = false
  }
}
