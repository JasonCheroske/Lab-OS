---
created: 2026-04-05
updated: 2026-04-05
status: phase-2-planned
---

# Meta lab template (phase 2 — placeholder)

> **Status:** Planned. This directory will contain the meta-lab archetype template, derived from the canonical `lab-os-lab` surface minus development-archive and personal artifacts.

## Intended contents

When populated, this tree will provide:

```
meta/
  lab/              ← knowledge layer scoped to lab-building and Lab OS development
  docs/             ← Lab OS methodology docs, architecture, runbooks, ADRs
  root/             ← README.md, AGENTS.md for the meta-workshop context
  .ai/              ← harness namespace with lab-building skills (lab-init, flow-diagram)
  scripts/          ← init-lab.mjs, validate-lab.mjs, promote-stage.mjs, etc.
  examples/         ← minimal-lab, hybrid-governance-lab fixtures
  template/         ← recursive: the agnostic + product-starter archetypes
  schema/           ← lab.schema.json
  lab.yaml          ← meta lab.yaml at appropriate maturity stage
```

## Who should use this template

Someone who wants to **build labs**—operate the meta-workshop, create new archetypes, incubate reference labs under `.tmp/`, run the Lab OS development loop itself, or extend it for their organization.

This is the **workshop-building workshop**—not a product workspace. Choosing meta means operating at the Lab OS level, not just using it as a foundation.

## How to populate this template

1. Identify the subset of `lab-os-lab` that represents the meta-workshop surface (exclude `.tmp/`, personal artifacts, release artifacts).
2. Run the harness personal artifact filter (see [COPY_READY_INVENTORY.md](../../docs/40-release/COPY_READY_INVENTORY.md)).
3. Copy the filtered result into this directory.
4. Update this README to document the archetype.

See [ADR-0003](../../docs/50-adr/ADR-0003-npm-create-three-options.md) for the full create-three-options design.
