---
created: 2026-04-17
updated: 2026-04-17
---

﻿# kubernetes/aws

<!-- emulator_supported: false (EKS: LocalStack Community does not emulate EKS control plane or node groups) -->

EKS cluster and managed node group. Cluster and node names follow the `{team}-{environment}` convention. `desired_size` is excluded from lifecycle to avoid drift on autoscaler changes (see `lab/behavior/SCALER_POLICY.md`).

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `cluster_version` | `string` | `"1.29"` | Kubernetes version |
| `vpc_id` | `string` | — | VPC to place the cluster in |
| `subnet_ids` | `list(string)` | — | Subnets for control plane (public + private) |
| `private_subnet_ids` | `list(string)` | — | Subnets for node groups |
| `endpoint_public_access` | `bool` | `true` | Allow public API access (set false in prod) |
| `node_instance_types` | `list(string)` | `["t3.medium"]` | Node instance types |
| `node_desired_size` | `number` | `2` | Initial desired node count (ignored after first apply) |
| `node_min_size` | `number` | `1` | Minimum nodes |
| `node_max_size` | `number` | `4` | Maximum nodes |
| `team` | `string` | — | Team name |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|---|---|
| `cluster_endpoint` | Kubernetes API endpoint |
| `cluster_certificate_authority_data` | Base64 CA data for kubeconfig (sensitive) |
| `node_role_arn` | Worker node IAM role ARN |
| `cluster_name` | EKS cluster name |
| `oidc_issuer_url` | OIDC issuer URL for IRSA |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
