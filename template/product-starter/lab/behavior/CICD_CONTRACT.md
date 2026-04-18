---
created: 2026-04-17
updated: 2026-04-17
---

# CI/CD contract

| Workflow | Trigger | Behavior |
| --- | --- | --- |
| `terraform-plan.yml` | Pull request touching `**/*.tf`, `**/*.tfvars`, `.github/workflows/terraform-plan.yml` | Setup Terraform, `init -backend=false`, `validate`, repo-wide `fmt -check` (plan + PR comment is org-specific; add OIDC + remote state + `actions/github-script` when ready). |
| `terraform-apply.yml` | Push to default branch (e.g. `main`) after merge | `plan` then `apply` with approval gate recommended (add `workflow_dispatch` or environment protection in real use). |
| `drift-detection.yml` | Schedule (nightly) + manual | `plan -detailed-exitcode`; notify on exit code 2 (Slack webhook secret placeholder). |

**Secrets / inputs (placeholders)**

- `AWS_ROLE_ARN` or static keys — **do not** commit; use GitHub Environments or OIDC.
- `SLACK_WEBHOOK_URL` for drift alerts.

**Lab OS note:** Exact job names and paths may evolve; update this table when workflows change.
