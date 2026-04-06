---
created: 2026-04-06
updated: 2026-04-06
---

# Lab Template

Template output:

```text
README.md
AGENTS.md
lab/
  intent/
  reality/
  delta/
  behavior/
  evidence/
docs/
  README.md
  project-structure.md
.ai/
  README.md
  skills/
  rules/
  .cursor/
    skills/
      lab-init/
    rules/
lab.yaml
```

Files under **`template/root/`** (`README.md`, `AGENTS.md`) merge into the **target root** on init. Root `docs/` is a **recommended companion** (mini-index + structure stub). **`.ai/`** is the harness namespace (skills, rules, and Cursor config); it ships with every initialized lab. These paths are copied for convenience and are **not** enforced by `validate`—you may delete or replace them.

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-04-05 | Add `.ai/` harness namespace to template output; update tree. | Lab OS seed |
| 2026-03-27 | Document `template/root/` consumer README + AGENTS.md in template output. | Lab OS seed |
| 2026-03-27 | Document optional root `docs/` in template output. | Lab OS seed |

