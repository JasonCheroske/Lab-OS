---
created: 2026-04-17
updated: 2026-04-17
---

# Readiness checklist (go-live)

Use per environment before promoting traffic or declaring “live.”

## Dev

- [ ] Backend reachable; lock table prevents concurrent writes
- [ ] `terraform apply` completed without errors
- [ ] Smoke test: VPC subnets exist; SQS sends/receives a test message
- [ ] No default passwords in tfvars; secrets in AWS Secrets Manager or CI vault

## Prod

- [ ] Change window communicated; rollback plan documented
- [ ] `prevent_destroy` on critical data paths reviewed
- [ ] Drift detection enabled and alerting tested
- [ ] On-call and owner listed in runbook (extend this file in your fork)

## Cross-cutting

- [ ] [READINESS_CHECKS.md](./READINESS_CHECKS.md) (Lab OS contract) satisfied for target stage
- [ ] ADRs updated if architecture diverged from [DESIGN_DECISIONS.md](../intent/DESIGN_DECISIONS.md)
