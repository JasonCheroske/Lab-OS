---
created: 2026-04-17
updated: 2026-04-17
---

# database/sql/gcp

<!-- emulator_supported: false (Cloud SQL: no GCP emulator available; requires real GCP project) -->

GCP Cloud SQL PostgreSQL instance with private IP and optional HA replica. Password should be sourced from Secret Manager in production.

## Outputs

| Name | Description |
|---|---|
| `db_endpoint` | Private IP address |
| `db_port` | PostgreSQL port (5432) |
| `db_identifier` | Connection name (project:region:instance) |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
