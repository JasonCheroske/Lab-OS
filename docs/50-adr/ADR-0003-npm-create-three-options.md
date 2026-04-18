---
created: 2026-04-06
updated: 2026-04-17
---

# ADR-0003: `lab-os create` three-option picker

**Status:** Accepted (implementation in progress — see implementation order below)
**Date:** 2026-04-05
**Updated:** 2026-04-07
**Intent:** Define the three-option interactive create experience for **`lab-os create`** (via **`npx lab-os@latest create`** or a global `lab-os` install), analogous to Svelte's `create-svelte` skeleton / demo app / library picker. Distribution is a **single** npm package `lab-os` (no separate `create-*` initializer).

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
npx lab-os@latest create                          # interactive: choose agnostic / product-starter / meta
lab-os create                                     # same after npm install -g lab-os
npx lab-os@latest create --template agnostic --target ./my-lab     # non-interactive
npx lab-os@latest create --template product-starter --target ./my-lab
npx lab-os@latest create --template meta --target ./my-lab
```

The interactive flow mirrors `create-svelte`: prompt for template, optional name/path, emit init output. Implemented via the Node.js `readline` API or a lightweight prompt library.

### Product lab starter content

The initial `product-starter` archetype is derived from `.tmp/terraform-reference-lab` after it passes the [PRODUCT_LAB_FILTER_RUNBOOK.md](../30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md) filter pass. Other product-starter archetypes may be added over time.

### Meta lab content

**Implemented (Option B — thin scaffold):** The published `template/meta/` archetype mirrors the agnostic knowledge and companion layout with copy tuned for meta-workshop intent. Full `scripts/`, nested templates, and examples are **not** vendored in the npm tarball to limit size; consumers clone [JasonCheroske/Lab-OS](https://github.com/JasonCheroske/Lab-OS) for the complete toolkit (documented in `template/meta/docs/META_WORKSHOP_SOURCE.md` after init). A heavier “full mirror” package layout remains a future option if demand warrants it.

## Implementation order

1. **Phase 1 (current):** `template/` = agnostic default. `lab-os init` works against it as today.
2. **Phase 2 (this ADR):** *(repository status — 2026-04-07)*
   - [x] `template/agnostic/` + `init-lab.mjs --template` (default `agnostic`).
   - [x] `template/product-starter/` populated from filtered `.tmp/terraform-reference-lab` (see [PRODUCT_LAB_FILTER_RUNBOOK.md](../30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md)).
   - [x] `template/meta/` thin scaffold (Option B).
   - [x] `lab-os create` interactive and non-interactive; tests cover agnostic, product-starter, and meta init/validate where applicable.

## Consequences

- Three distinct template trees under `template/agnostic/`, `template/product-starter/`, `template/meta/`.
- Current `template/` path deprecated and renamed as part of phase 2 migration.
- `lab-os.mjs` gains a `create` command; `init` command is kept for backwards compatibility (defaults to agnostic).
- Phase 1 foundation work (this sprint) does not break when phase 2 migration runs.

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-07 | Implemented agnostic/product-starter/meta, `lab-os create`, meta Option B; single-package distribution (no `create-lab-os`). | — |
| 2026-04-05 | Initial decision; phase 2 design stub. | — |
