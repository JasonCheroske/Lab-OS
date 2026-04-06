---
created: 2026-04-06
updated: 2026-04-06
---

# Phase 2 Package-Manager Backlog

**Intent:** Track package-manager release work after seed release stability; record completion and first publish.

**Related paths:** [README.md](README.md), [../40-release/RELEASE_NOTES_v0.1.0.md](../40-release/RELEASE_NOTES_v0.1.0.md), [../40-release/RELEASE_NOTES_v0.2.0.md](../40-release/RELEASE_NOTES_v0.2.0.md)

**Last reviewed:** 2026-04-06

## 1) Distribution targets

- npm public package (primary)
- Additional package managers (to be selected by demand)

## 2) Package shape decision

- Decide between:
  - single package (seed toolkit)
  - split packages (`core`, `cli`, `templates`)
- Define artifact boundaries for each package option.

## 3) Versioning and release policy

- Adopt semantic versioning policy for package artifacts.
- Define changelog format and release cadence.
- Define backward-compatibility policy for template/schema updates.

## 4) CI/CD publishing

- Add registry publish workflows with protected release triggers.
- Add dry-run publish verification in CI.
- Add package provenance/signing if required by target registry.

## 5) Credentials and governance

- Define registry ownership and token rotation policy.
- Store publish credentials in CI secrets only.
- Require approval gate before publish jobs can run.

## Implementation status (repository)

| Backlog section | Status | Where |
|-----------------|--------|--------|
| 1) Distribution targets | Done (npm primary) | `package.json`, [../40-release/NPM_REGISTRY_GOVERNANCE.md](../40-release/NPM_REGISTRY_GOVERNANCE.md) |
| 2) Package shape | Done (single package) | [../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md](../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md), `package.json` `files` |
| 3) Versioning and release policy | Done | [../40-release/SEMVER_POLICY.md](../40-release/SEMVER_POLICY.md), [CHANGELOG.md](../../CHANGELOG.md) |
| 4) CI/CD publishing | Done | `.github/workflows/npm-dry-run.yml`, `.github/workflows/npm-publish.yml`, `.github/workflows/external-bootstrap-smoke.yml` |
| 5) Credentials and governance | Done | [../40-release/NPM_REGISTRY_GOVERNANCE.md](../40-release/NPM_REGISTRY_GOVERNANCE.md) (`NPM_TOKEN`, GitHub Environment `npm-publish`) |

CLI entry point: `bin/lab-os.mjs` (`lab-os` on `PATH` after `npm install -g lab-os`).

**First public npm publish:** `lab-os@0.2.0` (tag `v0.2.0`), after GitHub Environment approval on the publish workflow.

## Exit criteria for Phase 2 start (historical)

These were met before treating Phase 2 as closed:

- Seed release `v0.1.0` completed ([GitHub](https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.1.0)).
- External bootstrap path verified (CI: `external-bootstrap-smoke`; see [../40-release/EXTERNAL_BOOTSTRAP_RECORD.md](../40-release/EXTERNAL_BOOTSTRAP_RECORD.md)).
- Package boundaries and ownership aligned with [ADR-0001](../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md).

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-04-06 | Exit criteria marked met; first npm publish noted as v0.2.0. | — |
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
| 2026-03-26 | Recorded implementation status (npm package, CI, governance docs, ADR-0001). | Jason Cheroske |
