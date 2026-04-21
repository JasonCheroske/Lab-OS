---
created: 2026-04-06
updated: 2026-04-21
---

# `.ai/` — AI workspace namespace

This folder is the **harness-agnostic AI workspace** for this lab. It is the live working copy that feeds `template/.ai/` at release time.

## Structure

```
.ai/
  README.md             ← this file
  skills/               ← agnostic skills (work in any harness)
  rules/                ← agnostic rules (work in any harness)
  .cursor/              ← Cursor-specific skills and rules
    skills/
      flow-diagram/
      lab-init/
    rules/
      lab-init-default.mdc
  .claude/              ← (placeholder) Claude-specific config
  .antigravity/         ← (placeholder) Antigravity or other harness config
```

## Principles

- **Agnostic content** (works regardless of harness) lives at `skills/` and `rules/` directly under `.ai/`.
- **Harness-specific content** lives under `.ai/.<harness>/`—skills, rules, or config meaningful only to that tool.
- **No identical-environment enforcement.** Contributors are encouraged to submit implementations for their own harness (`.ai/.claude/`, `.ai/.antigravity/`, etc.) alongside existing Cursor content. A variety matching how developers actually work is a feature.
- **Harness personal artifacts** (personal API keys, session state, individual preferences stored in harness config files) are **gitignored at the repo root**. This folder (`.ai/`) is always committed; personal config that lives at `.cursor/` or `.claude/` at the repo root is not.

## Harness-specific missteps → rules (left-shifted)

If a harness consistently makes a specific type of error in this lab's domain, encode the prevention as a **rule** in `.ai/.<harness>/rules/`. Systematic rules eliminate the need to pass workarounds informally—the fix is available to every session that uses the harness.

## How personal harness config is handled

Harness config folders at the **repo root** (`.cursor/`, `.claude/`, etc.) are **gitignored by default** (see `.gitignore`). Use the `harness-fetch` skill (see `skills/harness-fetch/`) to pull the pre-built harness config you need into your local working environment without committing personal artifacts.

## Sync with `template/.ai/`

**`lab-os-lab/.ai/` is the canonical live copy.** Before a release:

1. Sync `lab-os-lab/.ai/` → `template/.ai/` (see [RELEASE_RUNBOOK.md](../docs/30-runbooks/RELEASE_RUNBOOK.md)).
2. Verify `npm run lab:verify` still passes.
3. `template/.ai/` is what gets shipped in `init` output to every consumer lab.

## Workspace `.cursor/` relationship

`25-Lab-OS/.cursor/` (the parent workspace's Cursor discovery folder) mirrors `lab-os-lab/.ai/.cursor/` as a convenience for Cursor discovery in this workspace. It is maintained alongside `.ai/.cursor/`; prefer editing `.ai/.cursor/` as the source.
