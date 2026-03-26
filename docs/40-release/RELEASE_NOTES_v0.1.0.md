# Lab OS v0.1.0 (Seed Release)

**Intent:** Record highlights and verification evidence for `v0.1.0`.

**Related paths:** [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with release metadata.

`v0.1.0` is the first public GitHub seed release of `lab-os-lab`.

## Highlights

- Establishes canonical seed structure for AI-native engineering labs.
- Includes scaffold, validation, and maturity-promotion scripts.
- Adds release runbook and migration/release guidance for external users.
- Adds initialized starter lab tarball as primary onboarding artifact.

## Verification checklist

- [x] `npm test` passes
- [x] `npm run validate -- --target examples/minimal-lab` passes
- [x] `npm run validate -- --target examples/hybrid-governance-lab` passes
- [x] Temporary target promotion smoke-test passes
- [x] Secrets/artifact scan completed

## Notes

- Start here (primary): `lab-starter-v0.1.0.tar.gz` + checksum file.
- Advanced path: use `lab-os-lab` source to author custom seed variants.
- Package-manager release automation is intentionally deferred to Phase 2.

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
