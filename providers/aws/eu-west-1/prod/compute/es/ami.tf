data "aws_ami" "elasticsearch" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["elasticsearch_7.6.0_20200319220639"]
  }
  owners = ["self"]
}


