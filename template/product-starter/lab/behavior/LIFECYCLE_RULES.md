---
created: 2026-04-17
updated: 2026-04-17
---

# Lifecycle rules

## `prevent_destroy`

Use on stateful resources where accidental destroy is unacceptable (production databases, critical buckets). Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Remove or toggle only in controlled migrations.

## `ignore_changes`

Use when an external system legitimately mutates attributes (autoscaler `desired_size`, tags applied by org policy). Document each use in PR.

## `create_before_destroy`

Use when replacing resources where name conflicts or zero-downtime ordering matters.

**Governance:** `security_critical` and `architecture` changes affecting lifecycle rules require approvers per `lab.yaml`.
