---
created: 2026-04-06
updated: 2026-04-06
---

---
created: 2026-04-05
updated: 2026-04-05
---

# `.ai/` — AI workspace namespace

This folder is the **harness-agnostic AI workspace** for this lab. It ships with every lab initialized from the Lab OS seed and is designed to grow with the lab over time.

## Structure

```
.ai/
  README.md             ← this file
  skills/               ← agnostic skills (work in any harness)
  rules/                ← agnostic rules (work in any harness)
  .cursor/              ← Cursor-specific skills and rules
    skills/
      lab-init/         ← conversation-first design and scaffold workflow
    rules/
      lab-init-default.mdc
  .claude/              ← (add your Claude-specific config here)
  .antigravity/         ← (add your Antigravity or other harness config here)
```

## Principles

- **Agnostic content** (works regardless of harness) lives at `skills/` and `rules/` directly under `.ai/`.
- **Harness-specific content** lives under `.ai/.<harness>/`—skills, rules, or config meaningful only to that tool.
- **No identical-environment enforcement.** Add your own harness folder alongside `.cursor/`. Variety matching how your team actually works is a feature, not a problem.
- **Harness personal artifacts** (personal API keys, session state, individual preferences) are **gitignored at the repo root**. This folder (`.ai/`) is always committed; personal config that may live at `.cursor/` or `.claude/` at the repo root should not be committed.

## What ships by default

| Path | Purpose |
|------|---------|
| `.ai/skills/harness-fetch/` | Skill: pull your harness config from `.ai/.<harness>/` into your local working environment |
| `.ai/.cursor/skills/lab-init/` | Cursor skill: conversation-first design → scaffold workflow |
| `.ai/.cursor/rules/lab-init-default.mdc` | Cursor rule: prefer `/lab-init` for bootstrap intents |

## Harness-specific missteps → rules (left-shifted)

If your harness consistently makes a specific type of error for this lab's domain, encode the prevention as a **rule** in `.ai/.<harness>/rules/`. This left-shifts the fix into systematic prevention rather than an informal workaround passed between team members.

## Adding your own harness

1. Create `.ai/.<your-harness>/` following the same `skills/` / `rules/` layout.
2. Copy or adapt skills from `.ai/.cursor/` as a reference.
3. Document what the harness config does in a README inside that folder.
4. Optionally contribute harness-agnostic variants back to `.ai/skills/` or `.ai/rules/`.

## Personal harness config

Harness config folders at the **repo root** (`.cursor/`, `.claude/`, etc.) are gitignored by default. Use the `harness-fetch` skill to pull your pre-built config into your local working environment without committing personal artifacts:

```text
/harness-fetch
```
