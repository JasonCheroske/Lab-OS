---
created: 2026-04-17
updated: 2026-04-17
---

﻿# IAM — Why not abstracted

See **ADR-TR-008** in `.lab/intent/DESIGN_DECISIONS.md` for the full rationale. Short version:

AWS IAM Roles + Policies, Azure Managed Identity + Role Assignments, and GCP Service Accounts + IAM Bindings have fundamentally different permission models. A common interface would either:
- Expose the most restrictive common subset (useless in practice), or
- Leak provider-specific concepts through the abstraction (defeats the purpose).

Each cloud's IAM module is fully cloud-native and is not validated by `validate-contracts.mjs`.

## Module paths

| Cloud | Path | Primary resources |
|---|---|---|
| AWS | `modules/iam/aws/` | `aws_iam_role`, `aws_iam_policy`, `aws_iam_role_policy_attachment` |
| Azure | `modules/iam/azure/` | `azurerm_user_assigned_identity`, `azurerm_role_assignment` |
| GCP | `modules/iam/gcp/` | `google_service_account`, `google_project_iam_member` |

## Design guideline

Workload identity (injecting per-workload IAM identities into Kubernetes pods) should use:
- AWS: IRSA (IAM Roles for Service Accounts) via `oidc_issuer_url` from the `kubernetes/aws` module
- Azure: Workload Identity via `oidc_issuer_url` from the `kubernetes/azure` module
- GCP: Workload Identity via `google_service_account_iam_binding` + GKE annotation
