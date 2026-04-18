locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/${local.name_prefix}"
  retention_in_days = var.log_retention_days
  tags              = merge(local.common_tags, var.tags)
}
