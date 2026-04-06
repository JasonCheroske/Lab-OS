---
created: 2026-03-31
updated: 2026-03-31
---

# Lab Contract

**Intent:** Define required artifacts and behaviors for each initialized lab.

**Related paths:** [README.md](README.md), [../20-governance/GOVERNANCE_MODEL.md](../20-governance/GOVERNANCE_MODEL.md)

**Last reviewed:** 2026-03-27 — optional root onboarding (`README.md`, `AGENTS.md`) and `docs/` companions; validation requirements unchanged.

## Required artifacts

- `lab.yaml`
- Knowledge layer at **either** repo-root `lab/` **or** `.lab/` (same subtree below that root):
  - `intent/ARCHITECTURE_TARGET.md`
  - `reality/IMPLEMENTATION_MAP.md`
  - `delta/GAP_MAP.md`
  - `behavior/GOVERNANCE_POLICY.md`
  - `evidence/READINESS_CHECKS.md`

## Required behaviors

- protected changes are sign-off governed
- architecture decisions are linked to ADRs
- stage promotions pass validation gates

## Recommended companion documentation (optional)

These paths improve discoverability but are **not** required by `scripts/validate-lab.mjs`. Teams may remove them and still satisfy this contract unless you adopt a future stricter validation profile.

- Root **`README.md`** — human-facing startup arc, pillar links, validate/promote hints; points to Lab OS runbooks.
- Root **`AGENTS.md`** — suggested read order and rules of thumb for AI assistants.
- Root **`docs/README.md`** — short index linking `lab/*` pillars (and room for product doc links).
- Root **`docs/project-structure.md`** — starter tree and notes (e.g. engineering root vs git root).

Initialized seeds copy these from the template (via `template/root/` and `template/docs/`); maintaining them is a team choice.

## Change history


| Date       | Change summary                                   | Major structural change | Editor         |
| ---------- | ------------------------------------------------ | ----------------------- | -------------- |
| 2026-04-04 | Knowledge layer may be `lab/` or `.lab/` at repo root (same subtree); validation updated. | no                      | —              |
| 2026-03-27 | Documented optional root `README.md`, `AGENTS.md`, and `docs/*` companions; validation unchanged. | no                      | Jason Cheroske |
| 2026-03-26 | Migrated into taxonomy with governance metadata. | yes                     | Jason Cheroske |


## Sign-off (required only for major structural changes)


| Date       | Change reference        | Approver (human) | Role            | Decision |
| ---------- | ----------------------- | ---------------- | --------------- | -------- |
| 2026-03-26 | docs taxonomy migration | Jason Cheroske | senior_engineer | approved |


