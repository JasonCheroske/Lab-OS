---
name: lab-init
description: Bootstrap and validate the Lab OS seed repository. Use when the user says /lab-init or asks to bootstrap, initialize, or set up this lab/project for first use.
---

# Lab Init (Cursor Optional Shortcut)

Use this skill when setup intent is present, especially `/lab-init`.
This is a convenience path; non-Cursor users should use `npm run lab:init` and `npm run lab:verify`.

## Workflow

1. Confirm prerequisites:
   - Node.js 20+
   - npm 10+
2. Verify expected repo structure:
   - `docs/00-index/`, `docs/10-architecture/`, `docs/20-governance/`, `docs/30-runbooks/`, `docs/40-release/`, `docs/50-adr/`, `docs/60-reference/`, `docs/90-backlog/`
   - `schema/lab.schema.json`
   - `scripts/init-lab.mjs`, `scripts/validate-lab.mjs`, `scripts/promote-stage.mjs`
3. Run setup:
   - `npm install`
   - `npm run init -- --target ./.tmp/quickstart-lab`
4. Run validation:
   - `npm test`
   - `npm run validate -- --target ./.tmp/quickstart-lab`
   - `npm run validate -- --target ./examples/minimal-lab`
   - `npm run validate -- --target ./examples/hybrid-governance-lab`
5. Run promotion smoke check:
   - `npm run promote -- --target ./.tmp/quickstart-lab --to poc`
6. Report outcome using pass/fail format in `checklist.md`.

## Output format

- `Status`: pass/fail
- `Checks passed`: bullet list
- `Checks failed`: bullet list with command and error
- `Next action`: concrete fix steps

## Additional resources

- Detailed execution checklist: [checklist.md](checklist.md)
- Trigger and output examples: [examples.md](examples.md)
