---
created: 2026-03-31
updated: 2026-03-27
---

# Phase 2 Package-Manager Backlog

**Intent:** Track deferred package-manager release work after seed release stability.

**Related paths:** [README.md](README.md), [../40-release/RELEASE_NOTES_v0.1.0.md](../40-release/RELEASE_NOTES_v0.1.0.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with backlog metadata.

This backlog starts after GitHub seed release stability is confirmed.

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

## Exit criteria for Phase 2 start

- Seed release `v0.1.0` has completed.
- At least one external user has successfully bootstrapped from seed docs.
- Package boundaries and ownership are approved.

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
| 2026-03-26 | Recorded implementation status (npm package, CI, governance docs, ADR-0001). | Jason Cheroske |
