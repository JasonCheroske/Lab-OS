---
created: 2026-04-17
updated: 2026-04-17
---

# Governance policy (Lab OS contract)

Human sign-off is required for merges that affect protected blast-radius categories. See `lab.yaml` → `governance.approvalMatrix`.

**Operational detail** lives in:

| Topic | Document |
| --- | --- |
| CI/CD behavior | [CICD_CONTRACT.md](./CICD_CONTRACT.md) |
| Cluster autoscaler vs desired capacity | [SCALER_POLICY.md](./SCALER_POLICY.md) |
| SQS / DLQ / three-strike flow | [FAILOVER_POLICY.md](./FAILOVER_POLICY.md) |
| `prevent_destroy` / `ignore_changes` | [LIFECYCLE_RULES.md](./LIFECYCLE_RULES.md) |

Agents may author changes; **humans** approve merges and production applies.
