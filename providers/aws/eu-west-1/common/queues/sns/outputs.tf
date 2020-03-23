output "ios_topic" {
  value = aws_sns_topic.ios.arn
}

output "android_topic" {
  value = aws_sns_topic.android.arn
}
