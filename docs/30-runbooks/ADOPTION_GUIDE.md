---
created: 2026-03-31
updated: 2026-03-31
---

# Adoption Guide

**Intent:** Describe recommended adoption sequence for teams onboarding Lab OS using **plant → plan → sprout**.

**Related paths:** [README.md](../../README.md), [SEED_STARTUP_RUNBOOK.md](SEED_STARTUP_RUNBOOK.md), [RELEASE_RUNBOOK.md](RELEASE_RUNBOOK.md), [../00-index/DOCS_MAP.md](../00-index/DOCS_MAP.md), [../60-reference/FOUNDATIONS_VOCABULARY.md](../60-reference/FOUNDATIONS_VOCABULARY.md)

**Last reviewed:** 2026-03-27 — plant / plan / sprout; optional root onboarding files on init.

## Vocabulary

See [FOUNDATIONS_VOCABULARY.md](../60-reference/FOUNDATIONS_VOCABULARY.md) for **Lab**, **Seed**, **Plant**, **Plan**, **Sprout**, and **Meta-lab**.

## Adoption arc

```mermaid
flowchart LR
  seed[Seed_or_toolkit]
  root[Chosen_folder_root]
  plan_step[Plan_with_AI]
  sprout_step[Sprout_bind_structure]
  seed --> root
  root --> plan_step
  plan_step --> sprout_step
  sprout_step --> workspace[Lab_workspace]
```

### 1. Plant

- Choose the **repository or folder root** that will own `lab.yaml` and `lab/`.
- Introduce the skeleton:
  - From this repo: `npm run init -- --target <your-root>` (after `npm install`), or use `npm run lab:init` for the bundled pipeline; or
  - From a release tarball: extract so `<your-root>` contains `lab.yaml` and `lab/`.

### 2. Plan

- With your team and AI, shape the work **before** deep implementation: architecture anchors, unknowns, directory layout, diagrams, validation gates (conversation-first `/lab-init` Phase A when using Cursor).
- Fill or extend **intent / reality / delta** under `lab/` as understanding improves.
- Fill or extend **root `docs/`** alongside `lab/*`: the seed copies `docs/README.md` and `docs/project-structure.md` as optional companions—treat them as your mini-index and structure sketch, or replace them with your own doc layout (they are not validation-gated).
- Use **root `README.md`** and **`AGENTS.md`** (also optional) as the default entry for humans and assistants; they summarize startup and link to the longer [Seed startup runbook](SEED_STARTUP_RUNBOOK.md) in this repository.

### 3. Sprout

- Commit to the lab as your **workspace**: enforce governance (sign-offs for protected areas), run **validate** regularly, and **promote** maturity only when evidence passes.
- **Sprout is practically irreversible**—there is no automated un-sprout; plan the root deliberately.

### 4. Operate

- Enforce sign-off for protected changes.
- Validate in CI where possible.
- Promote stage only when evidence gates pass.

## Command mapping (this repository)

| Phase | Example commands |
|-------|-------------------|
| Plant | `npm install`, `npm run init -- --target ./path/to/root` |
| Plan | Edit `lab/intent/*`, `lab/reality/*`, `lab/delta/*`, optional root `README.md` / `AGENTS.md`, and optional root `docs/*`; use `/lab-init` for design-first tailoring |
| Operate | `npm run validate -- --target <root>`, `npm run promote -- --target <root> --to <stage>`, `npm test` |

### Labs that live under a subpath (engineering root ≠ git root)

When `lab.yaml` and `lab/` live in a **nested folder** inside this clone (for example a product workshop under `.tmp/` or `packages/`), pass that folder to validate: `npm run validate -- --target path/to/workshop`. From inside the workshop, the same check is often wired as `npm run validate` with `--target .` in that folder’s `package.json`. See optional companion docs under that lab’s `docs/project-structure.md` for the git-root vs workshop-root table (example pattern in the datalab-mcp workshop).

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
| 2026-03-27 | Plant → plan → sprout; optional root `README.md`, `AGENTS.md`, and `docs/` on init; link seed startup runbook. | Jason Cheroske |
| 2026-03-27 | Subpath labs: `--target` to workshop root; pointer to nested `docs/project-structure.md` pattern. | Jason Cheroske |
