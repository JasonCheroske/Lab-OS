---
created: 2026-04-17
updated: 2026-04-17
---

﻿# kubernetes/azure

<!-- emulator_supported: false (AKS: no Azure emulator available; requires real Azure subscription) -->

AKS cluster with a user-assigned managed identity and autoscaling node pool. `node_count` is excluded from lifecycle to prevent drift on cluster autoscaler changes (see `lab/behavior/SCALER_POLICY.md`).

## Outputs

| Name | Description |
|---|---|
| `cluster_endpoint` | AKS API server host |
| `cluster_certificate_authority_data` | CA certificate (sensitive) |
| `node_role_arn` | Managed identity principal ID |
| `cluster_name` | AKS cluster name |
| `oidc_issuer_url` | OIDC issuer for workload identity |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
