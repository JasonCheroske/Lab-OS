---
created: 2026-04-06
updated: 2026-04-06
---

# ADR-0002: `.ai/` harness namespace, seed symmetry, and fork model

**Status:** Accepted
**Date:** 2026-04-05
**Intent:** Define the `.ai/` folder as a harness-agnostic AI workspace namespace that ships with every initialized Lab OS lab, establish the seed-vs-package boundary, and record the fork/diverge policy for downstream labs.

## Context

Lab OS is a meta-workshop: it scaffolds **other** workshops (labs). A published seed must give consumers a **symmetric foundation**—the same productive structure a real workspace uses—without bundling the Lab OS development archive. The primary gap was that `.ai/` (skills, rules, harness config) was present in the canonical `lab-os-lab` repo but absent from `template/` and therefore absent from every initialized lab. Separately, there was no explicit policy on what "using Lab OS" vs "furthering Lab OS" means, or how downstream labs should relate to the canonical repository.

## Decisions

### 1. `.ai/` is the harness-agnostic AI workspace namespace

The `.ai/` folder is the canonical location for AI workspace content in any Lab OS–based lab. Its internal structure is:

```
.ai/
  README.md             ← namespace description and gitignore policy
  skills/               ← agnostic skills (work in any harness)
  rules/                ← agnostic rules (work in any harness)
  .cursor/              ← Cursor-specific skills and rules
  .claude/              ← Claude-specific config (contributor-submitted)
  .antigravity/         ← other harness config (contributor-submitted)
```

Agnostic content lives at `skills/` and `rules/` directly under `.ai/`. Harness-specific content lives under `.ai/.<harness>/`. Contributors are encouraged to submit their own harness implementations; the lab benefits from variety that matches how developers actually work. No identical-environment enforcement.

### 2. Harness personal artifacts are gitignored at the repo root

Harness config folders at the repo root (`.cursor/`, `.claude/`, etc.) contain personal artifacts (API keys, session state, individual preferences) that must not be committed. These are **gitignored by default** at the lab root. The `harness-fetch` skill (see `template/.ai/skills/harness-fetch/`) provides a harness-agnostic workflow for users to pull the pre-built config they need into their local environment without committing it.

### 3. Harness-specific missteps are left-shifted into rules

If a harness consistently makes a domain-specific error in the lab's context, that pattern becomes a **rule** in `.ai/.<harness>/rules/`. Systematic rules eliminate the need to pass workarounds informally. The fix is available to every session that opens the lab in that harness.

### 4. `template/.ai/` is the canonical seed source; `lab-os-lab/.ai/` is the live copy

- **`lab-os-lab/.ai/`** is the canonical live working copy—edited in place as Lab OS evolves.
- **`template/.ai/`** is the snapshot that ships in `init` output; it is synced from `lab-os-lab/.ai/` as a release step (see [RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)).
- **`init-lab.mjs`** copies `template/.ai/` to the target root alongside `lab/`, `docs/`, and root files.
- **`package.json` `files`** already globs `template/`—no additional configuration required.

### 5. Seed = agnostic foundation, not the Lab OS development archive

The init output (`template/`) is the **agnostic foundation** a consumer workspace uses. It does **not** include Lab OS development-only paths (`tests/generation.test.mjs`, `examples/` fixtures, `docs/90-backlog`, release workflows, `.tmp/`). The npm package may ship those paths so operators can run `validate` and `init` against target folders; they do not appear inside any consumer's initialized tree.

### 6. Furthering vs using Lab OS

- **Furthering Lab OS:** clone the canonical `lab-os-lab` repository, work on template/scripts/docs/schema, open a pull request. This is the standard open-source contribution path.
- **Using Lab OS:** install/use the npm package or run `init` into a target tree; maintain a fork or private clone of **that lab**; no obligation to PR unless improvements are intended for upstream.

### 7. Two tracks: agnostic seed and meta scaffold

| Track | Purpose | Where |
|-------|---------|-------|
| **Agnostic seed** | Immediate sculpting on a clean foundation | Anywhere: consumer root, greenfield |
| **Meta lab scaffold** | Incubate a product lab with full meta context, then extract | Canonical Lab OS repo, `.tmp/<lab>/` |

The **same template** is the base layer for both tracks. Extraction (`.tmp/my-lab` → new git remote) only changes where the remote lives; it does not change the bloomed-workspace character of the lab.

### 8. Product lab: bloomed workspace, no sequels

A **product lab** is a workspace that has almost irreversibly bloomed: deployed and embedded in how people work, not reducible to a single artifact. It adapts in place over time; there are no sequels in the sense of "v2 as a separate factory." Its `.ai/` bundle is expected to diverge from the generic seed as domain-specific rules and skills accumulate—that is legitimate fork behavior, not drift.

Before a matured product lab is promoted to a `product-starter` archetype, it requires a **filter pass** (see [PRODUCT_LAB_FILTER_RUNBOOK.md](../30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md)) to remove personal artifacts and non-transferable project-specific content.

## Consequences

- Every initialized lab gets a `.ai/` workspace with skills and rules from day one.
- `tests/generation.test.mjs` asserts the `.ai/` paths are present after init.
- `LAB_CONTRACT.md` notes `.ai/` as a recommended (not required) companion.
- A `harness-fetch` skill (phase 2) will handle personal harness config setup without committing artifacts.
- The npm three-option create picker (agnostic / product-starter / meta) is deferred to phase 2 (see ADR-0003 when written).

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-05 | Initial decision. | — |
