---
created: 2026-04-06
updated: 2026-04-06
---

# Seed startup runbook

**Intent:** Describe how to begin work in an **initialized Lab OS folder** (after plant)—the same narrative as plant → plan → sprout, written for the **consumer workspace** (not only the meta-lab).

**Related paths:** [ADOPTION_GUIDE.md](ADOPTION_GUIDE.md), [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md), [../60-reference/FOUNDATIONS_VOCABULARY.md](../60-reference/FOUNDATIONS_VOCABULARY.md)

**Last reviewed:** 2026-04-05

## What you have

A new root includes at minimum:

- **`lab.yaml`** — metadata and maturity stage.
- **`lab/`** — intent, reality, delta, behavior, evidence (required for validation).
- **Optional companions** (recommended, not validated): root **`README.md`**, **`AGENTS.md`**, **`docs/README.md`**, **`docs/project-structure.md`**, and **`.ai/`** (harness namespace — see below).

You may delete optional companions and still pass validation; most teams keep them for onboarding.

## Plant (already done for tarball / init)

You already placed the seed at the chosen folder root. Confirm `lab.yaml` and `lab/` exist.

## Plan

- Read **root `README.md`** and **`AGENTS.md`** if present (default entry for humans and assistants).
- Open **`docs/README.md`** at your workspace root for the pillar map.
- Fill **`lab/intent/ARCHITECTURE_TARGET.md`**, **`lab/reality/IMPLEMENTATION_MAP.md`**, and **`lab/delta/GAP_MAP.md`** as understanding improves—prefer small updates over monolithic dumps.
- Maintain **`docs/project-structure.md`** so "where things live" matches reality (engineering root vs git root, packages, services).
- Use **`lab/behavior/GOVERNANCE_POLICY.md`** to record how sign-off and protected areas work for *this* team.

Planning-first workflows (e.g. Cursor **`/lab-init`**) can precede heavy coding; the lab files remain the durable record.

## Sprout

- Treat this root as the **workspace**: decisions and evidence accumulate under `lab/`.
- **Sprouting is practically irreversible**—there is no automated un-sprout; choose the root deliberately.
- Add application code in whatever layout fits; reflect it in `docs/project-structure.md`.

## Set up your AI harness (`.ai/`)

The seed ships a **`.ai/`** folder that is the harness-agnostic AI workspace for this lab.

```
.ai/
  README.md             ← namespace description
  skills/               ← agnostic skills (any harness)
  rules/                ← agnostic rules (any harness)
  .cursor/              ← Cursor skills and rules
  .claude/              ← Claude config (add your own)
  .antigravity/         ← other harness config (add your own)
```

**To activate your harness config locally:**

Run the `harness-fetch` skill for guided setup:

```text
/harness-fetch
```

Or manually copy or symlink `.ai/.<your-harness>/` content to where your harness expects it at the repo root. Personal harness artifacts (API keys, session state) are **gitignored**—never commit them.

**To add your own harness:**

1. Create `.ai/.<your-harness>/` with `skills/` and `rules/` subfolders.
2. Add your harness config following the same conventions as `.cursor/`.
3. Update `.ai/README.md` to document the new harness entry.

## Operate: validate and promote

Validation checks **required** artifacts and schema—not optional root docs.

From a **Lab OS toolkit** checkout (`lab-os-lab` with `npm install`):

```bash
npm run validate -- --target <your-root>
npm run promote -- --target <your-root> --to <stage>
```

Using the **`lab-os`** CLI:

```bash
npx lab-os@latest validate --target <your-root>
npx lab-os@latest promote --target <your-root> --to poc
```

Run **validate** frequently (including in CI when possible). Run **promote** only when **`lab/evidence/READINESS_CHECKS.md`** and team policy support the next stage.

## When optional files get in the way

Teams may replace **root `README.md`**, **`AGENTS.md`**, **`docs/*`**, or **`.ai/`** with their own conventions. Keep **`lab/`** and **`lab.yaml`** aligned with [LAB_CONTRACT](../10-architecture/LAB_CONTRACT.md) unless you intentionally leave the Lab OS profile.

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-04-05 | Added `.ai/` harness namespace section; updated reviewed date. | — |
| 2026-03-27 | Initial seed startup runbook; consumer play for initialized labs. | Jason Cheroske |
