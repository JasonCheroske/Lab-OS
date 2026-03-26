# Documentation Governance

This project follows a strict documentation taxonomy by default, with explicit adaptation allowed when project scope changes.

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
