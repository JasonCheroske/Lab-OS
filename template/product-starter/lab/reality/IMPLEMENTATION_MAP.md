---
created: 2026-04-17
updated: 2026-04-17
---

# Implementation map (Lab OS contract)

Maps **Lab OS knowledge** to **Terraform code** in this repo.

| Lab OS / knowledge doc | Code path |
| --- | --- |
| Module contracts | [`MODULE_CONTRACTS.md`](./MODULE_CONTRACTS.md) ↔ `modules/*/variables.tf`, `outputs.tf` |
| Dependency graph | [`DEPENDENCY_MAP.md`](./DEPENDENCY_MAP.md) ↔ `environments/*/main.tf` |
| What is provisioned | [`ARCHITECTURE.md`](./ARCHITECTURE.md) ↔ all `*.tf` |

**Code roots**

| Area | Path |
| --- | --- |
| Reusable modules | `modules/vpc`, `modules/eks`, `modules/database`, `modules/messaging` |
| Environment roots | `environments/_bootstrap`, `environments/dev`, `environments/prod` |
| CI/CD | `.github/workflows/` |
| Local emulation | `tests/localstack/` |
