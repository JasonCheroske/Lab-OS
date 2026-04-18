---
created: 2026-04-17
updated: 2026-04-17
---

# Plan reading guide

**Before apply**

1. Scan for **destroy** actions — any unexpected `-/+` or destroy is a stop signal.
2. Check **module** boundaries — changes should align with the PR intent.
3. Verify **data** sources — no accidental dependency pulls from wrong env.

**Symbols**

- `+` create, `-` destroy, `~` update in-place, `-/+` replace

**Safety**

- Run plan with read-only credentials where possible.
- Post plan to PR (see `terraform-plan.yml`) for human review.
- For production, require second approver per `lab.yaml` governance.
