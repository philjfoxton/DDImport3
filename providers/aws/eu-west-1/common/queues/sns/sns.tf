resource "aws_sns_topic" "ios" {
  name = "pfm-ios"
}

resource "aws_sns_topic" "android" {
  name = "pfm-android"
}