locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = { Environment = var.environment; ManagedBy = var.team; Owner = coalesce(var.owner, var.team) }
}

resource "aws_ecr_repository" "this" {
  name                 = var.name != "" ? var.name : "${local.name_prefix}-registry"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(local.common_tags, var.tags)
}
