---
created: 2026-04-17
updated: 2026-04-17
---

# Module contracts

Summarized interface; source of truth is each module’s `variables.tf` and `outputs.tf`.

## `modules/vpc`

| Inputs (representative) | Outputs |
| --- | --- |
| `name_prefix`, `cidr_block`, `azs`, `enable_nat_gateway`, `tags` | `vpc_id`, `cidr_block`, `private_subnet_ids`, `public_subnet_ids` |

## `modules/eks`

| Inputs (representative) | Outputs |
| --- | --- |
| `cluster_name`, `cluster_version`, `subnet_ids`, `node_instance_types`, `tags` | `cluster_endpoint`, `cluster_certificate_authority_data`, `node_role_arn`, `oidc_issuer_url` (if enabled) |

## `modules/database`

| Inputs (representative) | Outputs |
| --- | --- |
| `engine`, `instance_class`, `allocated_storage`, `db_subnet_ids`, `tags` | `db_endpoint`, `db_port`, `db_identifier` |

## `modules/messaging`

| Inputs (representative) | Outputs |
| --- | --- |
| `queue_name`, `max_receive_count` (redrives before DLQ), `tags` | `queue_url`, `queue_arn`, `dlq_url`, `dlq_arn` |
