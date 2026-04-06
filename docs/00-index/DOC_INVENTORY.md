---
created: 2026-04-06
updated: 2026-04-06
---

# Documentation Inventory and Classification

This inventory maps existing documents into the canonical taxonomy for `lab-os-lab`.

## Current to target mapping

| Current path | Target bucket | Target path |
|---|---|---|
| `docs/LAB_OS_MANIFESTO.md` | `20-governance` | `docs/20-governance/LAB_OS_MANIFESTO.md` |
| `docs/LAB_CONTRACT.md` | `10-architecture` | `docs/10-architecture/LAB_CONTRACT.md` |
| `docs/GOVERNANCE_MODEL.md` | `20-governance` | `docs/20-governance/GOVERNANCE_MODEL.md` |
| `docs/KNOWLEDGE_GRAPH_MODEL.md` | `10-architecture` | `docs/10-architecture/KNOWLEDGE_GRAPH_MODEL.md` |
| `docs/MATURITY_MODEL.md` | `20-governance` | `docs/20-governance/MATURITY_MODEL.md` |
| `docs/FOUNDATIONS_VOCABULARY.md` | `60-reference` | `docs/60-reference/FOUNDATIONS_VOCABULARY.md` |
| `docs/ADOPTION_GUIDE.md` | `30-runbooks` | `docs/30-runbooks/ADOPTION_GUIDE.md` |
| `docs/MIGRATION_CHECKLIST.md` | `40-release` | `docs/40-release/MIGRATION_CHECKLIST.md` |
| `docs/RELEASE_RUNBOOK.md` | `30-runbooks` | `docs/30-runbooks/RELEASE_RUNBOOK.md` |
| `docs/RELEASE_NOTES_v0.1.0.md` | `40-release` | `docs/40-release/RELEASE_NOTES_v0.1.0.md` |
| `docs/PHASE2_PACKAGE_MANAGER_BACKLOG.md` | `90-backlog` | `docs/90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md` |
| `docs/COPY_READY_INVENTORY.md` | `40-release` | `docs/40-release/COPY_READY_INVENTORY.md` |
| `docs/00-index/templates/PATTERN_CARD_TEMPLATE.md` | `00-index` | `docs/00-index/templates/PATTERN_CARD_TEMPLATE.md` |
| `docs/60-reference/PATTERN_CARDS_MAINTAINER_PRACTICE.md` | `60-reference` | `docs/60-reference/PATTERN_CARDS_MAINTAINER_PRACTICE.md` |

## Notes

- Taxonomy is strict by default but can be adapted to project needs.
- Structural documents require change history entries on each update.
- Major structural changes require sign-off entries.
- Every Markdown file must include YAML **`created`** / **`updated`** frontmatter per [DOC_GOVERNANCE.md](DOC_GOVERNANCE.md); **`created` ≤ `updated`** always; **one** top block only (no stacked ISO duplicates—`--check` enforces). Refresh with `node scripts/add-md-frontmatter.mjs` after bulk moves; use **`--force`** to recompute from git, **`--fix-order`** to fix inverted ISO pairs without git, and **`--check`** / **`npm run docs:check-frontmatter`** (also run from [`lab:verify`](../../scripts/lab-verify.mjs)) to fail CI if ordering or stacked blocks are wrong.
