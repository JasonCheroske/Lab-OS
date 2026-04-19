---
created: 2026-04-17
updated: 2026-04-17
---

﻿# messaging/aws

<!-- emulator_supported: true (LocalStack: SQS fully emulated including redrive policies) -->

SQS primary queue, DLQ, and redrive policy implementing the three-strike failover pattern. Queue names follow `{team}-{environment}-jobs` and `{team}-{environment}-jobs-dlq`. The `queue_url` output is the cross-cloud wire point: inject it into workloads as `TASK_QUEUE_URL` regardless of which cloud is active.

See `.lab/behavior/FAILOVER_POLICY.md` for the three-strike semantics.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `max_receive_count` | `number` | `3` | Redrive threshold (three strikes) |
| `visibility_timeout_seconds` | `number` | `30` | Queue visibility timeout |
| `retention_seconds` | `number` | `1209600` | Message retention (14 days) |
| `team` | `string` | — | Team name |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|---|---|
| `queue_url` | Primary SQS URL — inject as `TASK_QUEUE_URL` into workloads |
| `queue_arn` | Primary queue ARN |
| `dlq_url` | Dead-letter queue URL |
| `dlq_arn` | Dead-letter queue ARN |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
