# Lab Init Checklist

Use this checklist when `/lab-init` is triggered.

## Preconditions

- [ ] Node.js version is 20 or newer
- [ ] npm version is 10 or newer
- [ ] repository root is `lab-os-lab`

## Structure checks

- [ ] `docs/00-index/DOCS_MAP.md` exists
- [ ] `docs/00-index/DOC_GOVERNANCE.md` exists
- [ ] `docs/10-architecture/README.md` exists
- [ ] `docs/20-governance/README.md` exists
- [ ] `docs/30-runbooks/README.md` exists
- [ ] `docs/40-release/README.md` exists
- [ ] `docs/60-reference/README.md` exists
- [ ] `docs/90-backlog/README.md` exists

## Commands

```bash
npm install
npm run lab:init -- ./.tmp/quickstart-lab
npm run lab:verify
```

Explicit CLI equivalent:

```bash
npm run init -- --target ./.tmp/quickstart-lab
npm test
npm run validate -- --target ./.tmp/quickstart-lab
npm run validate -- --target ./examples/minimal-lab
npm run validate -- --target ./examples/hybrid-governance-lab
npm run promote -- --target ./.tmp/quickstart-lab --to poc
```

## Result template

```text
Status: PASS|FAIL
Checks passed:
- ...
Checks failed:
- ...
Next action:
- ...
```
