# Output values
output "main_queue_url" {
  description = "main sqs queue url"
  value       = aws_sqs_queue.main.url
}

output "main_queue_arn" {
  description = "main sqs queue arn"
  value       = aws_sqs_queue.main.arn
}

output "dead_letter_queue_url" {
  description = "dead letter sqs queue url"
  value       = aws_sqs_queue.dlq.url
}

output "dead_letter_queue_arn" {
  description = "dead letter sqs queue arn"
  value       = aws_sqs_queue.dlq.arn
}
