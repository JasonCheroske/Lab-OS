---
created: 2026-04-17
updated: 2026-04-17
---

﻿---
created: 2026-04-04
updated: 2026-04-04
---

# Architecture target (Lab OS contract)

This file satisfies the Lab OS **intent** pillar contract. Authoritative narrative lives alongside it.

| Document | Purpose |
| --- | --- |
| [PURPOSE.md](./PURPOSE.md) | Why this lab exists; audience; two-layer model |
| [DESIGN_DECISIONS.md](./DESIGN_DECISIONS.md) | ADRs and structural rationale |
| [SKILL_GUIDE.md](./SKILL_GUIDE.md) | How to navigate the lab by experience level |

**Target state:** A reference Terraform workspace with reusable `modules/`, isolated `environments/*` state, GitHub Actions for plan/apply/drift, pre-commit quality gates, and LocalStack-first AWS compatibility documented in `.lab/reality/ARCHITECTURE.md`.
