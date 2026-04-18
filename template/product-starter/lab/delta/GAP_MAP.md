---
created: 2026-04-17
updated: 2026-04-17
---

# Gap map (Lab OS contract)

Known gaps between **documented target** and **current maturity** (`experiment`).

| Gap | Severity | Notes |
| --- | --- | --- |
| EKS on LocalStack | medium | LocalStack EKS coverage is limited; use real AWS or accept reduced fidelity for learning. |
| Remote state buckets | medium | `_bootstrap` must be applied against real AWS (or full LocalStack parity) before dev/prod backends work. |
| CI secrets | low | GitHub workflows use placeholder roles and webhooks; wire before production. |
| Terratest | low | Tests are stubbed until LocalStack is running in CI. |
| Checkov / tflint in Lab OS validate | low | Declared in `lab.yaml` but not executed by `validate-lab.mjs`; enforce in pre-commit and Actions. |
| **Extraction hardening (deferred)** | low | Phase 2: add lab-root `package.json` + lockfile; colocate `validate-contracts.mjs` so CI uses `--target .` instead of monorepo path; refresh `docs/project-structure.md` to reflect `scripts/` existence. Not blocking lab operation; required before standalone extraction to a new remote. See `lab-os-lab` plan `symmetrical_lab_os_seed_81ce62e6`. |

Promotion note: before promoting to **pilot**, resolve or accept all **medium** gaps in sign-off.
The **extraction hardening** gap is explicitly deferred to phase 2 and does not block promotion to pilot.
