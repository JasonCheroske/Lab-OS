---
created: 2026-04-17
updated: 2026-04-17
---

# database/sql/azure

<!-- emulator_supported: false (PostgreSQL Flexible Server: not emulated by Azurite; requires real Azure subscription) -->

Azure Database for PostgreSQL Flexible Server with optional zone-redundant HA. Password should be sourced from Key Vault in production.

## Outputs

| Name | Description |
|---|---|
| `db_endpoint` | Server FQDN |
| `db_port` | PostgreSQL port (5432) |
| `db_identifier` | Server name |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
