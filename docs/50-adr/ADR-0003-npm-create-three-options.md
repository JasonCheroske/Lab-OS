---
created: 2026-04-05
updated: 2026-04-05
---

# ADR-0003: `npm create lab-os` three-option picker

**Status:** Planned (phase 2)
**Date:** 2026-04-05
**Intent:** Define the three-option interactive create experience for `npm create lab-os` (and `npx lab-os create`), analogous to Svelte's `create-svelte` skeleton / demo app / library picker.

## Context

Today `lab-os init` initializes a single agnostic template everywhere. Three distinct starting-point archetypes have been identified:

1. **Agnostic lab** — the clean foundation for sculpting and immediate use.
2. **Product lab starter** — an opinionated, domain-demonstrating starter that teams may adopt and adapt.
3. **Meta lab** — the full Lab OS meta-workshop for building labs and contributing to Lab OS itself.

Mixing all three into one template path is not practical. Each archetype has a distinct knowledge layer shape, companion docs, and `.ai/` content appropriate to its purpose.

## Decision

### The three options

| # | Name | Svelte analogy | Who it is for | What it materializes |
|---|------|---------------|---------------|----------------------|
| 1 | **Agnostic lab** | Skeleton | Immediate sculpting from a clean base | `lab.yaml`, knowledge tree, `docs/`, `.ai/`, `README.md`, `AGENTS.md`. No domain opinions. |
| 2 | **Product lab starter** | Demo app | Teams wanting a richer, opinionated starting point demonstrating the full docs → tests → code triad | Foundation + example domain scaffolding (contracts, CI shape, module/service structure). Repurposable. |
| 3 | **Meta lab** | Library | Building labs, operating the meta-workshop, contributing to Lab OS | Full Lab OS working surface: knowledge layer scoped to lab-building, scripts, template, examples, `.tmp/` conventions, full rules/skills for lab-building work. |

### Template tree structure

```
template/
  agnostic/          ← current template/ becomes this (default for init today)
    lab/
    docs/
    root/
    .ai/
    lab.yaml
  product-starter/   ← example domain starter (e.g. Terraform multi-cloud)
    lab/
    docs/
    root/
    .ai/
    scripts/
    lab.yaml
  meta/              ← full meta-workshop surface
    lab/
    docs/
    root/
    .ai/
    scripts/
    examples/
    lab.yaml
```

Current `template/` remains the `agnostic` default. Migration: rename to `template/agnostic/` and update `init-lab.mjs` to resolve `template/agnostic/` as the default when no `--template` flag is given.

### CLI design

```bash
npm create lab-os               # interactive picker: choose agnostic / product-starter / meta
npx lab-os create               # same
npx lab-os create --template agnostic --target ./my-lab     # non-interactive
npx lab-os create --template product-starter --target ./my-lab
npx lab-os create --template meta --target ./my-lab
```

The interactive flow mirrors `create-svelte`: prompt for template, optional name/path, emit init output. Implemented via the Node.js `readline` API or a lightweight prompt library.

### Product lab starter content

The initial `product-starter` archetype is derived from `.tmp/terraform-reference-lab` after it passes the [PRODUCT_LAB_FILTER_RUNBOOK.md](../30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md) filter pass. Other product-starter archetypes may be added over time.

### Meta lab content

The `meta` archetype ships the Lab OS development surface (current `lab-os-lab` without the `.tmp/` scratch and personal artifacts). It is the full workshop for building and incubating labs.

## Implementation order

1. **Phase 1 (current):** `template/` = agnostic default. `lab-os init` works against it as today.
2. **Phase 2 (this ADR):**
   - Rename `template/` → `template/agnostic/`; update `init-lab.mjs` to default to `agnostic`.
   - Create `template/product-starter/` stub; run filter pass on Terraform reference lab to populate it.
   - Create `template/meta/` stub from Lab OS canonical surface.
   - Add `create` command to `lab-os.mjs` with interactive picker.
   - Update tests: `init --template agnostic` still passes all existing assertions.

## Consequences

- Three distinct template trees under `template/agnostic/`, `template/product-starter/`, `template/meta/`.
- Current `template/` path deprecated and renamed as part of phase 2 migration.
- `lab-os.mjs` gains a `create` command; `init` command is kept for backwards compatibility (defaults to agnostic).
- Phase 1 foundation work (this sprint) does not break when phase 2 migration runs.

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-05 | Initial decision; phase 2 design stub. | — |
