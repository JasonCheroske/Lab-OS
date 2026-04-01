---
name: flow-diagram
description: >-
  Builds and maintains GitDiagram-style Mermaid architecture flowcharts tied to real repo paths,
  with path validation and Markdown link tables (not diagram click). Use when the user says
  /flow-diagram or /flow-driagram (typo), asks for an architecture flowchart, system map, lab
  diagram refresh, gitdiagram-style diagram, Mermaid flowchart update, or keeping the canonical
  diagram in sync with the codebase.
created: 2026-03-31
updated: 2026-03-31
---

# Flow diagram (`/flow-diagram`)

Maintain a **single canonical** `flowchart TD` that maps Lab OS **control plane, lab model, tooling, knowledge, verification, and distribution**. Mirror [gitdiagram](https://github.com/ahmedkhaleel2004/gitdiagram) in spirit only (no hosted pipeline): **structure → graph → Mermaid → path validation → fix drift**, same as GitDiagram’s tree-backed nodes and retry-on-bad-paths idea described in that project’s README.

**House style reference:** [docs/60-reference/EXAMPLE_FLOWCHART.md](../../../docs/60-reference/EXAMPLE_FLOWCHART.md) (gitdiagram export; match colors and subgraph style; **omit `click` for this repo’s canonical doc**—see below).

**Canonical output file (default):** [docs/60-reference/LAB_ARCHITECTURE_FLOWCHART.md](../../../docs/60-reference/LAB_ARCHITECTURE_FLOWCHART.md). Override only if the user names another path.

**Initial multi-diagram product design** (broader than this skill): see [lab-init](../lab-init/SKILL.md).

## Cursor and GitHub: links live in tables

- **Do not rely on Mermaid `click`** for the canonical Lab OS diagram. Cursor’s Markdown preview (and many other Mermaid embeds) **do not** expose interactive `click` targets the way github.com’s full viewer might.
- After the fenced diagram, include **Node lookup** (Mermaid ID → path → `https://github.com/<owner>/<repo>/blob|tree/<branch>/...`) and **Relationship lookup** (from → label → to; solid vs dotted).
- That preserves gitdiagram-style **colors** (`classDef` / `class`) in the chart while making navigation **reliable in Cursor and on GitHub**.

## Layout for document height

- At the top of the fence, use `%%{init: {'flowchart': {'useMaxWidth': true}, 'themeVariables': {'fontSize': '12px'}}}%%` so the diagram **respects preview width** and type is slightly smaller.
- Prefer **stacked subgraphs** (declare top-to-bottom story: control → docs/verification → lab model → tooling → distribution).
- Inside busy subgraphs, set `direction TB` and define nodes **in read order** so the renderer tends to grow **tall** rather than one ultra-wide row.
- For **five or more siblings** (facets, scripts), use **two nested subgraph rows** with `direction LR` per row (e.g. 3+2 or 3+3); subgraph title `[" "]` avoids an extra visible band name.
- **Compact labels** in the diagram—filenames, `dir/`, short roles—full prose only in the **Node lookup** table.
- **Single-line** labels with **` · `**; **no `<br/>` / `<br>`** in Cursor-optimized docs.

## When to use

- New architecture diagram or first-time canonical file.
- Layout changes (new scripts, `lab/` subtrees, schema moves, docs buckets).
- Release or docs pass where the map must match reality.
- After merges that rename or delete paths cited in the diagram.

## Lab OS anchors (verify; do not invent)

Inventory these before editing diagrams:

| Area | Typical paths |
|------|----------------|
| Manifest & schema | `lab.yaml`, `schema/lab.schema.json` |
| Template | `template/` |
| Lab instance | `lab/intent/`, `lab/reality/`, `lab/delta/`, `lab/evidence/`, `lab/behavior/` |
| Tooling | `scripts/*.mjs`, `bin/lab-os.mjs` |
| Knowledge | `docs/` |
| Fixtures | `examples/` |
| Tests | `tests/` |

Use `package.json` `scripts` and repo tree to decide which scripts deserve their own nodes vs. grouping.

## Workflow

1. **Inventory** — List or skim tree for the anchors above; read `lab.yaml`, `README.md` section on structure if present.
2. **Draft** — Update or create one Mermaid block: subgraphs by concern; `node_*` / `group_*` IDs; edges with clear verb labels; **keep `classDef` / `class` for the gitdiagram color system**.
3. **Path validation** — Every path hinted in node labels or **lookup tables** must exist in the workspace. If something moved, update the diagram and tables together.
4. **Table URLs** — Use `blob` for files and `tree` for directories. Resolve owner/repo/branch from `git remote get-url origin` (and default branch, often `main`).
5. **Syntax check** — Node IDs: no spaces. Quote edge labels that contain parentheses or ambiguous characters. See [reference.md](reference.md).
6. **Deliver** — Canonical markdown = intro + one fenced `mermaid` block **without `click` lines** + **Node lookup** + **Relationship lookup**. Optional “What changed” bullets for PRs.

Repeat steps 3–5 until there are no broken paths or parse errors.

## Diagram conventions (match EXAMPLE_FLOWCHART)

| Element | Rule |
|--------|------|
| Init | Optional `%%{init: ... useMaxWidth ... fontSize ...}%%` first line inside fence |
| Layout | `flowchart TD`; subgraphs for bounded contexts; prefer vertical stacking + row bands for wide lists |
| Node IDs | Stable `node_*`; subgraphs `group_*` |
| Labels | **Compact** in-diagram (paths / one word); details in lookup table; **` · `** only; no `<br/>` |
| Edges | `-->` primary; `-.->` secondary/supporting; `|"verb text"|` on links |
| Styling | `classDef` / `class` — keep the gitdiagram palette for this repo |
| Links | **Tables after the diagram**, not `click` inside it (canonical doc) |

## Output contract

- File opens with YAML **`created`** / **`updated`** per [DOC_GOVERNANCE.md](../../../docs/00-index/DOC_GOVERNANCE.md); bump **`updated`** on each content change to the diagram or tables.
- One top-level fenced code block with language `mermaid`.
- No `click` directives in the canonical file.
- **Node lookup** and **Relationship lookup** tables with GitHub URLs (or updated base per remote).
- No secrets in labels or URLs.
- Optional changelog bullets after tables.

## Quality checklist

- [ ] Subgraphs still match major concerns of this repo.
- [ ] Every cited path exists; table links are `blob`/`tree` correct.
- [ ] Table base URL matches this repo’s GitHub (or user’s remote).
- [ ] Mermaid parses (IDs, quotes, subgraph syntax).
- [ ] `docs/60-reference/README.md` links the canonical file if newly added.

## Before finishing (agent)

- Description and triggers match the user request (including `/flow-driagram` typo).
- `SKILL.md` stays the single entrypoint; deeper detail only in linked sibling files.

## Additional detail

- [reference.md](reference.md) — Mermaid edge cases, tables vs `click`, portability notes.
- [examples.md](examples.md) — prompts, deliverable shape, skeleton, anti-patterns.
