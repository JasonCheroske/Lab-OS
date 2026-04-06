---
created: 2026-04-06
updated: 2026-04-06
---

# Pattern cards (maintainer practice)

**Intent:** Describe how maintainers compare sprouted labs to the Lab OS seed **without** storing private repository identifiers in the public `lab-os-lab` git tree.

**Related paths:** [../00-index/templates/PATTERN_CARD_TEMPLATE.md](../00-index/templates/PATTERN_CARD_TEMPLATE.md), [FOUNDATIONS_VOCABULARY.md](FOUNDATIONS_VOCABULARY.md)

**Last reviewed:** 2026-03-27

## Where cards live

Keep **per-repo pattern cards** in a directory **outside** this repository (for example a sibling folder next to `lab-os-lab` on your machine). Use the template in `docs/00-index/templates/PATTERN_CARD_TEMPLATE.md` or the twin file in that local folder.

Reason: public clones should not ship names, paths, or commercial context of unrelated codebases.

## Rigor target (aspirational)

Lab OS aims for a **more refined and rigorous** default than ad-hoc sprouted repos:

- A clear **entry index** (table or `README`) so agents load minimal context.
- A single **project structure** view (tree + annotations) answering “where things live.”
- **Subsystem-sized** docs instead of meg files; **change history** on structural pages.
- Explicit **research vs shipped** and **current vs archived** lines when versioning appears.
- **Validation gates** documented next to maturity promotion (see [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md)).

Use local pattern cards to diff “what works in the wild” against this bar and feed **backlog** items—not to paste proprietary paths into `lab-os-lab`.

## Workflow

1. Copy `PATTERN_CARD_TEMPLATE.md` to a local card file.
2. Fill topology and IA honestly after one sprouted lab stabilizes.
3. Under **Extract for Lab OS**, write only **generalizable** bullets (safe if leaked).
4. Open issues or backlog entries in `lab-os-lab` from those bullets—never attach private cards to public issues verbatim.

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-03-27 | Initial maintainer practice and rigor target. | Jason Cheroske |
