---
created: 2026-04-06
updated: 2026-04-06
---

# Lab OS v0.2.1 (CLI working directory fix)

**Intent:** Patch release for `npx` / global `lab-os` installs: init and other commands resolve relative paths from the user’s shell directory.

**Related paths:** [CHANGELOG.md](../../CHANGELOG.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-04-06

## Highlights

- **Fixed:** `lab-os` CLI runs child scripts with `cwd` set to the caller’s current working directory; script paths are absolute so templates still load from the package install root.
- **Regression test:** CLI `init` from a temporary `cwd` writes `lab.yaml` under that directory, not under `node_modules/lab-os`.

## Verification checklist

- [ ] `npm test` passes
- [ ] `npm run validate -- --target examples/minimal-lab` passes
- [ ] Smoke: from an empty temp folder, `npx lab-os@latest init ./smoke-lab` creates `./smoke-lab/lab.yaml`

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-04-06 | Initial v0.2.1 release notes. | — |
