locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))
  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-store"
  tags   = merge(local.common_tags, var.tags)
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.encryption ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
