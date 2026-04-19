---
created: 2026-04-17
updated: 2026-04-17
---

﻿# database/sql/aws

<!-- emulator_supported: partial (LocalStack Community: RDS emulation is limited — endpoint is available but engine behaviour is not fully replicated) -->

RDS instance (PostgreSQL or MySQL), subnet group, and security group. Instance name follows the `{team}-{environment}` convention. Password should be sourced from Secrets Manager in production (see `.lab/intent/DESIGN_DECISIONS.md` ADR-TR-008).

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `vpc_id` | `string` | — | VPC to place the security group in |
| `db_subnet_ids` | `list(string)` | — | Private subnets for RDS |
| `allowed_cidr_blocks` | `list(string)` | — | CIDRs allowed to reach DB port |
| `engine` | `string` | `"postgres"` | DB engine |
| `engine_version` | `string` | `"15.5"` | Engine version |
| `instance_class` | `string` | — | RDS instance class |
| `allocated_storage` | `number` | `20` | Storage in GiB |
| `db_username` | `string` | — | Master username |
| `db_password` | `string` | — | Master password (sensitive) |
| `db_port` | `number` | `5432` | DB port |
| `multi_az` | `bool` | `false` | Enable Multi-AZ (prod) |
| `team` | `string` | — | Team name |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|---|---|
| `db_endpoint` | RDS hostname |
| `db_port` | RDS port |
| `db_identifier` | RDS instance identifier |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
