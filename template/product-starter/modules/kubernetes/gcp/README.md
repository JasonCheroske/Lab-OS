---
created: 2026-04-17
updated: 2026-04-17
---

﻿# kubernetes/gcp

<!-- emulator_supported: false (GKE: no GCP emulator available; requires real GCP project) -->

GKE cluster with a dedicated node pool and autoscaling. `initial_node_count` is excluded from lifecycle to prevent drift on cluster autoscaler changes (see `.lab/behavior/SCALER_POLICY.md`).

## Outputs

| Name | Description |
|---|---|
| `cluster_endpoint` | GKE master endpoint (HTTPS) |
| `cluster_certificate_authority_data` | CA certificate (sensitive) |
| `node_role_arn` | Node service account email |
| `cluster_name` | GKE cluster name |
| `oidc_issuer_url` | Workload Identity issuer URL |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
