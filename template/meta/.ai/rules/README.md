---
created: 2026-04-17
updated: 2026-04-17
---

# Agnostic rules

Place rules here that apply **regardless of which AI harness** you use. Agnostic rules should be written as plain guidance that any agent or human can follow without harness-specific config syntax.

When editing **Markdown** in the Lab OS seed or a generated lab: use **exactly one** YAML frontmatter block at the top (`created` / `updated`); do not stack a second `---` block before the title or body. See [`docs/00-index/DOC_GOVERNANCE.md`](../../../../docs/00-index/DOC_GOVERNANCE.md) and [`scripts/add-md-frontmatter.mjs`](../../../../scripts/add-md-frontmatter.mjs).

## What belongs here

- Standing conventions that should apply in every AI session in this lab.
- Response patterns or constraints not tied to one tool's config format.

## What does not belong here

- Cursor `.mdc` rule files → use `.cursor/rules/` instead.
- Harness-specific config → use `.<harness>/` instead.
