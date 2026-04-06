---
created: 2026-04-06
updated: 2026-04-06
---

# Copy-Ready Inventory

**Intent:** Enumerate the canonical files included when the seed is redistributed and define the explicit boundary between init output (consumer tree) and npm-package-only paths.

**Related paths:** [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md), [../00-index/DOC_INVENTORY.md](../00-index/DOC_INVENTORY.md), [../50-adr/ADR-0002-ai-harness-namespace.md](../50-adr/ADR-0002-ai-harness-namespace.md)

**Last reviewed:** 2026-04-05

## npm package contents (`package.json` `files`)

Everything below ships in the `lab-os` npm tarball and is available when you run `npx lab-os@latest`:

- `README.md`
- `LICENSE`
- `.gitignore`
- `package.json`
- `package-lock.json`
- `bin/` (`lab-os.mjs` CLI entry point)
- `schema/lab.schema.json`
- `template/` (all starter artifacts — see init output below)
- `scripts/` (`init-lab.mjs`, `validate-lab.mjs`, `promote-stage.mjs`, `utils.mjs`, `validate-contracts.mjs`, `add-md-frontmatter.mjs`, `build-lab-tar.mjs`, `lab-init.mjs`, `lab-verify.mjs`)
- `docs/` (full meta documentation tree)
- `examples/` (`minimal-lab`, `hybrid-governance-lab`)
- `tests/generation.test.mjs`

## Init output: what lands in a consumer tree

When a user runs `npx lab-os@latest init --target <path>` (or `npm run init -- --target <path>`), **only** the following land in the target directory:

### Always copied (from `template/`)

| Source | Target | Notes |
|--------|--------|-------|
| `template/lab/` | `lab/` (or `.lab/`) | Required knowledge layer |
| `template/docs/` | `docs/` | Recommended companion (optional) |
| `template/root/README.md` | `README.md` | Recommended companion (optional) |
| `template/root/AGENTS.md` | `AGENTS.md` | Recommended companion (optional) |
| `template/.ai/` | `.ai/` | Harness namespace (recommended, not validated) |
| `template/lab.yaml` | `lab.yaml` | Required |

### Never in init output (npm-package-only)

The following exist in the npm package to support the toolkit but **do not** appear in consumer trees:

- `tests/generation.test.mjs` — Lab OS meta tests
- `examples/` — fixture labs used for Lab OS verification only
- `docs/90-backlog/` — Lab OS development backlog
- `docs/40-release/` — release runbooks and governance
- `docs/50-adr/` — Lab OS architectural decisions
- `scripts/` — toolkit executables (available via CLI, not copied)
- `.tmp/` — scratch; never committed or shipped
- `.github/workflows/` — Lab OS CI; does not ship to consumer

## Gitignore policy for harness personal artifacts

The following patterns should be in every initialized lab's `.gitignore` to prevent personal harness config from being committed:

```gitignore
# Personal harness config (API keys, session state, individual preferences)
# The .ai/ folder is committed; individual harness config at the repo root is not.
.cursor/settings.json
.cursor/chat/
.claude/
# Add other harness personal config patterns as needed
```

Note: `.cursor/rules/` and `.cursor/skills/` at the repo root may be committed if teams prefer to place skills there for Cursor discovery rather than under `.ai/.cursor/`. The `harness-fetch` skill helps teams set up their preferred discovery method without committing personal artifacts.

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-04-05 | Restructured into package vs init output sections; added gitignore policy for harness personal artifacts; added `.ai/` to init output. | — |
| 2026-03-26 | Moved to taxonomy path and refreshed inventory structure. | Jason Cheroske |
