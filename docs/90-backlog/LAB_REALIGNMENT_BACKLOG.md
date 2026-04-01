---
created: 2026-03-31
updated: 2026-03-31
---

# Lab realignment backlog

**Intent:** Track **generalized** improvements to the seed and docs rigor, derived from maintainer pattern-card practice—**no** private repository names or codenames.

**Related paths:** [../60-reference/PATTERN_CARDS_MAINTAINER_PRACTICE.md](../60-reference/PATTERN_CARDS_MAINTAINER_PRACTICE.md), [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md)

**Last reviewed:** 2026-03-27

## How to use

Open tasks from here (or issues) using **safe** titles only. Do not paste proprietary pattern cards into public threads verbatim.

## Backlog items

- **Multi-slice index** — When one repository hosts parallel demos or products, support or document a clear index pattern (sections or slices) so agents load minimal context.
- **Numbered topic docs** — Consider conventions for numbered or prefixed topic documents where deep hierarchies improve skimming.
- **`References/` (or equivalent)** — Optional convention for curated external links separate from narrative docs.
- **Engineering root vs git root** — First-class guidance when the lab root is not the monorepo root (paths in `project-structure.md`, validation target docs).
- **Rigor checklist for doc indexes** — Short checklist (entry index, structure view, stale vs current) aligned with maintainer practice for structural pages. *(Partial: seed ships root `README.md` + `AGENTS.md` + [SEED_STARTUP_RUNBOOK](../30-runbooks/SEED_STARTUP_RUNBOOK.md); extend as needed.)*
- **Second validation profile (future)** — Optional `--strict` (or profile in config) that could require companion `docs/*`; out of scope until spec’d.

## Status

| Item | Status |
| --- | --- |
| Optional template `docs/` on init | Done (see LAB_CONTRACT companion section) |
| Remaining rows above | Not started |

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-03-27 | Note partial coverage of doc-index rigor item (seed onboarding + runbook). | Jason Cheroske |
| 2026-03-27 | Initial anonymized backlog from pattern-card themes. | Jason Cheroske |
