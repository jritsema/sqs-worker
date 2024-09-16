# main queue
resource "aws_sqs_queue" "main" {
  name                       = var.name
  message_retention_seconds  = 86400 # 1 day
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

# Dead Letter Queue
resource "aws_sqs_queue" "dlq" {
  name                       = "${var.name}-dlq"
  message_retention_seconds  = 1209600 # 14 days
  visibility_timeout_seconds = 30
}
