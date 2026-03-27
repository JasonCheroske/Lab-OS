# Lab OS

Lab OS is the canonical GitHub seed for AI-native engineering environments.

It extends normal CI/CD and Agile delivery with:

- explicit architecture and function-contract governance
- durable knowledge graph conventions
- reproducible lab scaffolding for teams using different AI systems

This repository is released as a **GitHub source seed** and as an **npm package** (`lab-os`). The initialized lab tarball remains the primary artifact for teams that want a copy-paste bundle without installing from a registry.

## Prerequisites

- Node.js 20+
- npm 10+

## Project structure

```text
lab-os-lab/
  docs/
  schema/
  template/
  scripts/
  examples/
  tests/
```

## npm package (Phase 2)

Install the toolkit from the public registry and use the `lab-os` CLI (same behavior as the npm scripts):

```bash
npm install -g lab-os
lab-os lab-init ./.tmp/quickstart-lab
lab-os lab-verify
```

Or run without a global install:

```bash
npx lab-os@latest init ./my-lab
npx lab-os@latest validate --target ./my-lab
```

Publishing, semver policy, and registry governance are documented under `docs/40-release/` (see `NPM_REGISTRY_GOVERNANCE.md`, `SEMVER_POLICY.md`) and ADR `docs/50-adr/ADR-0001-package-boundaries-and-npm-distribution.md`.

## Start here: initialized lab tarball (primary release path)

Create the release artifact:

```bash
npm run lab:tar -- v0.1.0
```

This creates:

- `.tmp/release-artifacts/lab-starter-v0.1.0.tar.gz`
- `.tmp/release-artifacts/lab-starter-v0.1.0.tar.gz.sha256`

End-user setup from tarball:

```bash
tar -xzf lab-starter-v0.1.0.tar.gz
cd lab-starter-v0.1.0
npm run validate -- --target .
npm run promote -- --target . --to poc
```

## Source seed path (advanced/custom seed authoring)

```bash
npm install
npm run lab:init
npm run lab:verify
```

By default, `npm run lab:init` targets `./.tmp/quickstart-lab`. You can pass a custom target:

```bash
npm run lab:init -- ./my-lab
```

## Quick start (explicit CLI equivalent)

```bash
npm install
npm run init -- --target ./.tmp/quickstart-lab
npm run validate -- --target ./.tmp/quickstart-lab
npm run promote -- --target ./.tmp/quickstart-lab --to poc
npm run lab:verify
```

## Cursor shortcut (optional)

Use `/lab-init` in Cursor to run the **conversation-first** workflow: design and tailor a project (ASCII tree, Mermaid, sprout handoff) before any scaffolding; optional **sprout** includes Lab OS seed commands when you choose that mode. See `.cursor/skills/lab-init/SKILL.md`. All npm paths above work without Cursor.

## Expected command output

- `npm run init` prints `Lab initialized at: ...`
- `npm run validate` prints `Validation passed for: ...`
- `npm run promote` prints `Stage promoted to: ...`
- `npm run lab:init` prints `[lab:init] complete: ...`
- `npm run lab:verify` prints `[lab:verify] complete`

## Validation matrix

Run this before opening or merging release PRs:

```bash
npm test
npm run validate -- --target ./examples/minimal-lab
npm run validate -- --target ./examples/hybrid-governance-lab
```

Promotion checks should run against a temporary target to avoid mutating checked-in examples.

## Release model

- Phase 1: GitHub release with initialized lab tarball as primary user artifact
- Phase 2: npm distribution (`lab-os`), semver policy, CI dry-run and tag publish workflows

See `docs/40-release/MIGRATION_CHECKLIST.md` for release sequencing, `docs/40-release/NPM_REGISTRY_GOVERNANCE.md` for publish credentials, and `docs/90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md` for backlog history and status.

## Troubleshooting

- `Validation failed: Missing required artifact`:
  run `npm run init -- --target <your-lab-path>` again.
- `Schema mismatch`:
  open `<target>/lab.yaml` and align fields with `schema/lab.schema.json`.
- `Promotion failed: Target stage must be higher...`:
  choose the next maturity stage (`experiment` -> `poc` -> `pilot` -> `production`).
