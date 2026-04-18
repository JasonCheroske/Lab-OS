---
created: 2026-04-17
updated: 2026-04-17
---

# Scaler policy (desired capacity)

**Problem:** Cluster autoscaler or managed scaling adjusts desired node count. Terraform might fight the live API if it keeps resetting capacity.

**Pattern:** On node groups or ASGs that are autoscaled, use:

```hcl
lifecycle {
  ignore_changes = [desired_size]
}
```

(or `desired_capacity` on classic ASGs — match your resource type.)

**Contract:** Infrastructure owns **min/max** and instance profile; the scaler owns **desired** in steady state. Document exceptions in PR when adding new node groups.
