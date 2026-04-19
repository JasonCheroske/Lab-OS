---
created: 2026-04-19
updated: 2026-04-19
---

# Lab OS v0.3.1 (default `.lab/` knowledge directory)

**Intent:** Patch release: `lab-os init` places the knowledge layer at repo-root **`.lab/`** by default; **`--knowledge-dir lab`** restores the previous **`lab/`** layout.

**Related paths:** [CHANGELOG.md](../../CHANGELOG.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-04-19

## Highlights

- **Changed:** `scripts/init-lab.mjs` default `--knowledge-dir` is **`.lab`** (was `lab`). `validate-lab.mjs` behavior unchanged; it still accepts exactly one of `.lab/` or `lab/` at the target root.
- **Docs/templates:** Companion READMEs, `docs/*`, and product-starter links updated so relative paths match **`.lab/`** after init.

## Verification checklist

- [ ] `node --test tests/generation.test.mjs` passes
- [ ] Smoke: `npx lab-os@0.3.1 init ./smoke-lab` creates `./smoke-lab/.lab/intent/ARCHITECTURE_TARGET.md`
- [ ] Alternate: `npx lab-os@0.3.1 init ./smoke-lab2 --knowledge-dir lab` creates `./smoke-lab2/lab/intent/ARCHITECTURE_TARGET.md`

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-04-19 | Initial v0.3.1 release notes. | Jason Cheroske |
