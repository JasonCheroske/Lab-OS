---
created: 2026-04-06
updated: 2026-04-17
---

# Product-starter archetype (Terraform multi-cloud)

Lab OS **product-starter** template: a governed knowledge layer plus a reference **Terraform** layout (multi-cloud modules, environments, CI workflows, tests). Derived from the meta-lab’s `.tmp/terraform-reference-lab` after a [product lab filter](../../docs/30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md) pass (placeholders only in `*.tfvars`; no committed secrets).

Initialized consumers get `lab/`, `docs/`, `.ai/`, `modules/`, `environments/`, `tests/`, `.github/`, and optional `.pre-commit-config.yaml` alongside `lab.yaml`.

Use:

```bash
lab-os init --template product-starter --target ./my-iac-lab
# or
lab-os create --yes --template product-starter --target ./my-iac-lab
```

See [ADR-0003](../../docs/50-adr/ADR-0003-npm-create-three-options.md).
