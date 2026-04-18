output "queue_url" {
  value       = aws_sqs_queue.this.url
  description = "Primary queue URL (pass to workloads / EKS env)."
}

output "queue_arn" {
  value       = aws_sqs_queue.this.arn
  description = "Primary queue ARN."
}

output "dlq_url" {
  value       = aws_sqs_queue.dlq.url
  description = "Dead-letter queue URL."
}

output "dlq_arn" {
  value       = aws_sqs_queue.dlq.arn
  description = "Dead-letter queue ARN."
}
