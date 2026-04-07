---
created: 2026-04-06
updated: 2026-04-06
---

# Lab OS v0.2.0 (npm + symmetrical seed)

**Intent:** Record highlights and verification evidence for `v0.2.0`.

**Related paths:** [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md), [CHANGELOG.md](../../CHANGELOG.md)

**Last reviewed:** 2026-04-06

`v0.2.0` is the first public **npm** release of the `lab-os` package and ships the **symmetrical seed**: every initialized lab includes the `.ai/` harness namespace (skills, rules, defaults).

## Highlights

- **npm:** `lab-os` published to the public registry; install with `npm install -g lab-os` or `npx lab-os@latest …`.
- **Symmetrical seed:** `template/.ai/` copied on `init`; investigation deck and Cursor defaults available from day one.
- **Governance:** ADR-0002 (harness namespace), ADR-0003 (three-option create, phase 2 design), `PRODUCT_LAB_FILTER_RUNBOOK.md`, `LEAN_FOUNDATIONS.md`; `COPY_READY_INVENTORY.md` documents init includes/excludes.
- **CLI:** `lab-os create` stub documents upcoming Svelte-style picker; `create` defers to `init` until phase 2.
- **Canonical GitHub:** repository URLs align with [JasonCheroske/Lab-OS](https://github.com/JasonCheroske/Lab-OS).

## Verification checklist

- [ ] `npm test` passes
- [ ] `npm run validate -- --target examples/minimal-lab` passes
- [ ] `npm run validate -- --target examples/hybrid-governance-lab` passes
- [ ] `npm run lab:verify` passes
- [ ] `npm publish --dry-run` passes (CI: `npm-dry-run` workflow)
- [ ] After tag push and approval: `npm view lab-os version` shows `0.2.0`
- [ ] Smoke: `npx lab-os@latest init ./.tmp/npm-smoke-<id>` (or `--target ./.tmp/npm-smoke-<id>`) from an empty parent folder produces `.ai/` paths **under that parent** (not under `node_modules/lab-os`); use **lab-os ≥ 0.2.1** for correct cwd behavior with positional paths.

## Notes

- **Tarball:** `lab-starter-v0.2.0.tar.gz` + checksum (optional path for teams not using npm).
- **Phase 2 follow-on:** interactive `create`, `template/agnostic` split, product-starter population (see ADR-0003).

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-04-06 | Initial v0.2.0 release notes. | — |
