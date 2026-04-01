---
created: 2026-03-31
updated: 2026-03-26
---

# Copy-Ready Inventory

**Intent:** Enumerate the canonical files included when the seed is redistributed.

**Related paths:** [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md), [../00-index/DOC_INVENTORY.md](../00-index/DOC_INVENTORY.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with release metadata.

- `README.md`
- `LICENSE`
- `.gitignore`
- `package.json`
- `package-lock.json`
- `docs/`
  - `00-index/`
  - `10-architecture/`
  - `20-governance/`
  - `30-runbooks/`
  - `40-release/`
  - `50-adr/`
  - `60-reference/`
  - `90-backlog/`
- `schema/lab.schema.json`
- `template/` (all starter artifacts)
- `scripts/` (`init-lab.mjs`, `validate-lab.mjs`, `promote-stage.mjs`, `utils.mjs`)
- `examples/` (`minimal-lab`, `hybrid-governance-lab`)
- `tests/generation.test.mjs`

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-03-26 | Moved to taxonomy path and refreshed inventory structure. | Jason Cheroske |
