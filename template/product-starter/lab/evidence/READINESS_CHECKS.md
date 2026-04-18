---
created: 2026-04-17
updated: 2026-04-17
---

# Readiness checks (Lab OS contract)

Minimum evidence before treating an environment as ready. Detailed per-environment steps: [READINESS_CHECKLIST.md](./READINESS_CHECKLIST.md).

**Experiment**

- [ ] `terraform fmt -check` clean for touched files
- [ ] `terraform validate` passes per root (`-backend=false` if backend not configured)
- [ ] `npm run validate -- --target <this-root>` (from Lab OS toolkit) passes

**PoC**

- [ ] Remote state bucket and lock table exist (`environments/_bootstrap` applied)
- [ ] `terraform plan` clean for dev and prod roots
- [ ] No secrets in committed `*.tfvars`

**Pilot**

- [ ] Pre-commit hooks pass (fmt, tflint, checkov, terraform-docs)
- [ ] PR plan workflow posts plan output

**Production**

- [ ] Drift detection workflow green
- [ ] Checkov policy for critical issues enforced in pipeline
- [ ] Terratest (or equivalent) passing against LocalStack or staging
