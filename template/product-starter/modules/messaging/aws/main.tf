locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "aws_sqs_queue" "dlq" {
  name                      = "${local.name_prefix}-jobs-dlq"
  message_retention_seconds = var.retention_seconds
  tags                      = merge(local.common_tags, var.tags)
}

resource "aws_sqs_queue" "this" {
  name                       = "${local.name_prefix}-jobs"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(local.common_tags, var.tags)
}
