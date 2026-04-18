---
created: 2026-04-17
updated: 2026-04-17
---

# Dependency map

```mermaid
flowchart TD
  dev[environments_dev]
  prod[environments_prod]
  vpc[module_vpc]
  eks[module_eks]
  db[module_database]
  msg[module_messaging]
  dev --> vpc
  dev --> msg
  dev --> db
  dev --> eks
  prod --> vpc
  prod --> msg
  prod --> db
  prod --> eks
  eks -->|subnet_ids| vpc
  db -->|db_subnet_ids| vpc
```

**Output chaining**

- `vpc` → subnet IDs → `eks`, `database`
- `messaging` → `queue_url` / `queue_arn` → consumed by workloads (Kubernetes manifests or app config; environment can expose via outputs)

**Bootstrap**

- `_bootstrap` has **no** module dependencies; creates state storage only.
