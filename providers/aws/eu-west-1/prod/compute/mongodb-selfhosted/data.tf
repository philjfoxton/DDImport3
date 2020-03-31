data "aws_ami" "mongodb" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["mongodb_4.2.0_20200331084821"]
  }
  owners = ["self"]
}


