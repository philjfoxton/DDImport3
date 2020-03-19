resource "aws_sqs_queue" "dlq_queues" {
  for_each = toset(flatten([for e in local.sqs_env : [for n in local.queue_names : "Pfm-${e}-${n}"]]))
  name     = join("-", [each.value, "dlq"])


}

resource "aws_sqs_queue" "sqs_queues" {
  depends_on = [aws_sqs_queue.dlq_queues]
  for_each   = toset(flatten([for e in local.sqs_env : [for n in local.queue_names : "Pfm-${e}-${n}"]]))
  name       = each.value


  redrive_policy = jsonencode({

    deadLetterTargetArn = aws_sqs_queue.dlq_queues[each.value].arn
    maxReceiveCount     = 4

  })
}

