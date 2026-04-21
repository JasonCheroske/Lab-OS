---
created: 2026-04-06
updated: 2026-04-21
---

# Flow diagram — reference

## Doc file metadata

- Canonical Markdown outputs should carry YAML **`created`** / **`updated`** frontmatter when the repo follows that convention (Lab OS: [DOC_GOVERNANCE](https://github.com/JasonCheroske/Lab-OS/blob/main/lab-os-lab/docs/00-index/DOC_GOVERNANCE.md)). Bump **`updated`** whenever the diagram body or lookup tables change.

## Node and subgraph IDs

- Use **no spaces** in IDs: `node_init_lab` not `node init lab`.
- Avoid reserved or ambiguous tokens as bare subgraph IDs; prefer `group_tooling` with a quoted display title: `subgraph group_tooling["Tooling"]`.
- For a node with parentheses or punctuation in the **label**, keep the label inside `[...]` or `("...")`, not the ID.

## Edge labels

- Wrap the label in **quotes** when it contains parentheses, commas, slashes, or other characters that confuse the parser: `A -->|"checks against"| B`.
- Prefer short verb phrases: `"materializes"`, `"gates by"`, `"asserts"`.

## Solid vs dotted edges

- **`-->`** — operational or definitional dependency (the system “does” or “is shaped by” this).
- **`-.->`** — documentation, examples, tests, or soft/supporting relationships (mirrors, guides, regressions).

## Links: tables vs Mermaid `click`

- **Canonical doc:** put navigation in **Markdown tables** after the diagram (node ID, path, GitHub `blob`/`tree` URL). That works in **Cursor preview** and on **github.com**.
- **`click`** in Mermaid is **unreliable in Cursor** and other sandboxes; gitdiagram-style interactivity on the web does not transfer to the editor. Optional `click` may appear in archived examples such as [EXAMPLE_FLOWCHART.md](https://github.com/JasonCheroske/Lab-OS/blob/main/lab-os-lab/docs/60-reference/EXAMPLE_FLOWCHART.md)—do not copy **`click`** into the maintained canonical chart ([LAB_ARCHITECTURE_FLOWCHART.md](https://github.com/JasonCheroske/Lab-OS/blob/main/lab-os-lab/docs/60-reference/LAB_ARCHITECTURE_FLOWCHART.md)).
- Table URLs: files → `.../blob/<branch>/<path>`; directories → `.../tree/<branch>/<path>`.

## Styling (`classDef` / `class`)

- **Default:** use the **full** gitdiagram-style palette from [examples.md](examples.md) so diagrams match the house style (see [LAB_ARCHITECTURE_FLOWCHART.md](https://github.com/JasonCheroske/Lab-OS/blob/main/lab-os-lab/docs/60-reference/LAB_ARCHITECTURE_FLOWCHART.md)).
- [EXAMPLE_FLOWCHART.md](https://github.com/JasonCheroske/Lab-OS/blob/main/lab-os-lab/docs/60-reference/EXAMPLE_FLOWCHART.md) shows the same palette but with `<br/>` labels — copy **colors**, not multiline label style.
- If a target viewer strips classes, the diagram remains valid without them; styling can be omitted for maximum portability.

## Canvas size (width)

- `%%{init: {'flowchart': {'useMaxWidth': true}}}%%` makes many renderers scale the graph to the **container width** instead of growing arbitrarily wide.
- Pair with **shorter node text** and **row subgraphs** (3+3 instead of six in one band) so aspect ratio is closer to a tall document.

## Labels (Cursor vs GitHub)

- **House style:** use **one line per node** and **` · `** between parts. Avoid **`<br/>` / `<br>`** inside `["..."]` or `("...")`—many IDE previews print the tag literally or mangle brackets.
- Path hints: plain filenames or `dir/` at end of label is fine; they **must** match real paths and the lookup table.

## Bracket hints in labels

- Square brackets inside Mermaid quoted labels can interact badly with some parsers; prefer **no brackets** in diagram text and rely on the **Node lookup** table for paths.
