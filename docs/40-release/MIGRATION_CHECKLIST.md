# Migration Checklist

**Intent:** Provide release-day migration and verification sequence for shipping the canonical seed.

**Related paths:** [RELEASE_NOTES_v0.1.0.md](RELEASE_NOTES_v0.1.0.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with governance metadata.

1. Confirm release scope is GitHub seed only (package-manager distribution is deferred).
2. Run `npm install`.
3. Build initialized lab tarball and checksum:
   - `npm run lab:tar -- v0.1.0`
4. Run wrapper verification flow:
   - `npm run lab:init -- ./.tmp/release-smoke-<timestamp>`
   - `npm run lab:verify`
5. Run:
   - `npm run validate -- --target examples/minimal-lab`
   - `npm run validate -- --target examples/hybrid-governance-lab`
6. Run promotion smoke-test against a temporary initialized target:
   - `npm run init -- --target ./.tmp/release-smoke-<timestamp>`
   - `npm run promote -- --target ./.tmp/release-smoke-<timestamp> --to poc`
7. Verify tarball extraction path works:
   - `tar -xzf .tmp/release-artifacts/lab-starter-v0.1.0.tar.gz -C .tmp/release-artifacts`
   - `node scripts/validate-lab.mjs --target ./.tmp/release-artifacts/lab-starter-v0.1.0`
8. Confirm release docs are updated (`README.md`, release notes, runbook).
9. Scan for coupling terms (example: old host project names).
10. Tag release `v0.1.0` once checks pass.

## Change history

| Date | Change summary | Major structural change | Editor |
|---|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | yes | Jason Cheroske |

## Sign-off (required only for major structural changes)

| Date | Change reference | Approver (human) | Role | Decision |
|---|---|---|---|---|
| 2026-03-26 | docs taxonomy migration | Jason Cheroske | senior_engineer | approved |
