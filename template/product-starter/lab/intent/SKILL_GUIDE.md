---
created: 2026-04-17
updated: 2026-04-17
---

# Skill guide

## New to Terraform

1. Read [ARCHITECTURE.md](../reality/ARCHITECTURE.md) for what gets provisioned.
2. Open `environments/dev/main.tf` and follow module calls into `modules/`.
3. Read [PLAN_READING_GUIDE.md](../delta/PLAN_READING_GUIDE.md) before your first `terraform plan`.

## Comfortable with Terraform

1. Study [MODULE_CONTRACTS.md](../reality/MODULE_CONTRACTS.md) and [DEPENDENCY_MAP.md](../reality/DEPENDENCY_MAP.md).
2. Compare `environments/dev` vs `environments/prod` tfvars and backends.
3. Run pre-commit locally; align with [CICD_CONTRACT.md](../behavior/CICD_CONTRACT.md).

## Senior / SRE

1. Review [LIFECYCLE_RULES.md](../behavior/LIFECYCLE_RULES.md) and [DRIFT_POLICY.md](../delta/DRIFT_POLICY.md).
2. Own promotion gates in [VALIDATION_MATRIX.md](../evidence/VALIDATION_MATRIX.md).
3. Extend `_bootstrap` and GitHub OIDC as your org requires.

## AI agents

1. Start from [IMPLEMENTATION_MAP.md](../reality/IMPLEMENTATION_MAP.md) and `lab.yaml`.
2. Do not apply to production without human confirmation.
3. After edits, prefer `terraform fmt` and `terraform validate` on the touched root.
