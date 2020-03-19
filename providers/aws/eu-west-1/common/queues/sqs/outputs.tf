output "sqs_arn" {
  value = {
  for sqs in aws_sqs_queue.sqs_queues :
  replace(sqs.name, "/[.]$/", "") => replace(sqs.arn, "/[.]$/", "")
  }
}

output "sqs_dlq_arn" {
  value = {
  for sqs in aws_sqs_queue.dlq_queues :
  replace(sqs.name, "/[.]$/", "") => replace(sqs.arn, "/[.]$/", "")
  }
}



