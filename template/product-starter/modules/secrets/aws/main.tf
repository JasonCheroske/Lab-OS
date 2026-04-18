locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name != "" ? var.secret_name : "${local.name_prefix}-secret"
  recovery_window_in_days = 0
  tags                    = merge(local.common_tags, var.tags)
}
