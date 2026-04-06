---
created: 2026-04-06
updated: 2026-04-06
---

---
created: 2026-04-05
updated: 2026-04-05
status: phase-2-planned
---

# Product lab starter template (phase 2 — placeholder)

> **Status:** Planned. This directory will contain the product-starter archetype template once a reference product lab (e.g. Terraform reference lab) has passed the [PRODUCT_LAB_FILTER_RUNBOOK](../../docs/30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md) and been promoted to archetype status.

## Intended contents

When populated, this tree will provide:

```
product-starter/
  lab/              ← knowledge layer pre-filled with domain-specific examples
  docs/             ← docs including domain-specific project structure, diagrams, ADRs
  root/             ← README.md, AGENTS.md tailored for this domain
  .ai/              ← harness namespace with domain-specific rules/skills
  scripts/          ← domain validator scripts (e.g. validate-contracts.mjs)
  lab.yaml          ← starter lab.yaml at experiment stage
```

## Who should use this template

Teams who want a **richer, opinionated starting point** that demonstrates the full docs → tests → code triad in a real domain pattern. The policies and workflow are present to adopt, adapt, or replace—not as a ceiling, but as a working floor.

The template is **repurposable**: someone may prefer to adopt an existing lab's operational workflow rather than designing one from scratch. That is a valid and intentional path.

## How to populate this template

1. Run the filter pass in [PRODUCT_LAB_FILTER_RUNBOOK.md](../../docs/30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md) on a matured product lab.
2. Copy the filtered result into this directory.
3. Update this README to document the archetype.
4. Run `npm run lab:verify` to confirm the archetype passes all Lab OS checks.

See [ADR-0003](../../docs/50-adr/ADR-0003-npm-create-three-options.md) for the full create-three-options design.
