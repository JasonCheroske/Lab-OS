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

## Exit criteria for Phase 2 start

- Seed release `v0.1.0` has completed.
- At least one external user has successfully bootstrapped from seed docs.
- Package boundaries and ownership are approved.

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
