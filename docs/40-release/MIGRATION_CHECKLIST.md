---
created: 2026-04-06
updated: 2026-04-06
---

# Migration Checklist

**Intent:** Provide release-day migration and verification sequence for shipping the canonical seed and npm package.

**Related paths:** [RELEASE_NOTES_v0.2.0.md](RELEASE_NOTES_v0.2.0.md), [RELEASE_NOTES_v0.1.0.md](RELEASE_NOTES_v0.1.0.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-04-06

1. Confirm target version **v0.2.0** and release owner.
2. Run `npm install`.
3. Run tests and examples:
   - `npm test`
   - `npm run validate -- --target examples/minimal-lab`
   - `npm run validate -- --target examples/hybrid-governance-lab`
4. Build initialized lab tarball and checksum:
   - `npm run lab:tar -- v0.2.0`
5. Run wrapper verification flow:
   - `npm run lab:init -- ./.tmp/release-smoke-<timestamp>`
   - `npm run lab:verify`
6. Run promotion smoke-test against a temporary initialized target:
   - `npm run init -- --target ./.tmp/release-smoke-<timestamp>`
   - `npm run promote -- --target ./.tmp/release-smoke-<timestamp> --to poc`
7. Verify tarball extraction path works:
   - `tar -xzf .tmp/release-artifacts/lab-starter-v0.2.0.tar.gz -C .tmp/release-artifacts`
   - `node scripts/validate-lab.mjs --target ./.tmp/release-artifacts/lab-starter-v0.2.0`
   - Confirm `.tmp/release-artifacts/lab-starter-v0.2.0/.ai/` exists
8. Confirm `npm publish --dry-run` (or rely on CI `npm-dry-run` workflow on the release PR).
9. Confirm release docs are updated (`README.md`, `CHANGELOG.md`, `RELEASE_NOTES_v0.2.0.md`, runbooks).
10. Scan for coupling terms (example: old host project names).
11. Merge release PR, then tag and publish:
    - `git tag v0.2.0`
    - `git push origin v0.2.0`
    - Approve the **`npm-publish`** GitHub Environment job; confirm package appears on npm.
12. Post-release smoke: `npx lab-os@latest init --target ./.tmp/npm-smoke-<timestamp>` and validate.

## Change history

| Date | Change summary | Major structural change | Editor |
|---|---|---|---|
| 2026-04-06 | v0.2.0: npm publish steps, tarball v0.2.0, remove seed-only scope lock. | yes | — |
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | yes | Jason Cheroske |

## Sign-off (required only for major structural changes)

| Date | Change reference | Approver (human) | Role | Decision |
|---|---|---|---|---|
| 2026-03-26 | docs taxonomy migration | Jason Cheroske | senior_engineer | approved |
