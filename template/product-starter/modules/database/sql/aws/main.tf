locals {
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
}

resource "aws_security_group" "db" {
  name_prefix = "${local.name_prefix}-db-"
  vpc_id      = var.vpc_id
  description = "RDS access for ${local.name_prefix}"

  ingress {
    description = "DB port from allowed CIDRs"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, var.tags, { Name = "${local.name_prefix}-db-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = var.db_subnet_ids
  tags       = merge(local.common_tags, var.tags, { Name = "${local.name_prefix}-db-subnets" })
}

resource "aws_db_instance" "this" {
  identifier                 = "${local.name_prefix}-db"
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  username                   = var.db_username
  password                   = var.db_password
  port                       = var.db_port
  skip_final_snapshot        = true
  multi_az                   = var.multi_az
  publicly_accessible        = false
  apply_immediately          = true
  backup_retention_period    = 0
  delete_automated_backups   = true
  tags                       = merge(local.common_tags, var.tags)
}
