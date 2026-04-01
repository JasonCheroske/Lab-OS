---
created: 2026-03-31
updated: 2026-03-31
---

# Documentation Governance

This project follows a strict documentation taxonomy by default, with explicit adaptation allowed when project scope changes.

## Markdown frontmatter (`created` / `updated`)

Every Markdown file in this repository (including `README.md`, `CHANGELOG.md`, Cursor skills under `.cursor/skills/`, `docs/`, `template/`, `examples/`, and `lab/`) must start with a YAML block:

```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

- **`created`** — Date this path first appeared in version control (stable; change only if the file is replaced wholesale).
- **`updated`** — Date of the latest substantive content edit; bump it whenever you change meaning, structure, or operational behavior—not for typo-only fixes if you choose to skip (prefer bumping for any committed edit to keep history honest).

Structural and non-structural templates embed placeholder dates—replace with real values when instantiating. **Last reviewed** and change-history tables remain required where those templates say so; frontmatter is an additional machine- and reader-friendly anchor.

## Structural vs non-structural docs

- **Structural docs** define architecture, governance policy, release procedures, or canonical operating models.
- **Non-structural docs** are quick notes, examples, or localized guidance that do not redefine project structure/process.

## Major structural change policy

A change is **major** if it includes one or more of the following:

- taxonomy/folder remap
- canonical schema/model shifts
- governance policy rewrites
- runbook control-flow changes

Major structural changes require:

1. change-history entry
2. sign-off table entry by a human approver

## Editorial authority and provenance

- `Editor` attribution is human-only and represents final accountability.
- Agent/model/drill/builder systems are execution tools, not editorial authorities.
- Tool usage should be captured in a provenance note (for traceability), while sign-off remains human.
- Functional-anchor documents that define architecture, governance, and control-flow behavior require explicit human sign-off on substantive changes.

Minor changes require:

1. change-history entry

## Team exception model

Small senior teams may coordinate externally for review discussions, but major structural changes must still be recorded in-document with sign-off entries.
