---
created: 2026-03-31
updated: 2026-03-27
---

# GitHub Seed Release Runbook

**Intent:** Define the canonical run procedure for shipping `lab-os-lab` as a public GitHub seed release.

**Related paths:** [ADOPTION_GUIDE.md](ADOPTION_GUIDE.md), [../40-release/MIGRATION_CHECKLIST.md](../40-release/MIGRATION_CHECKLIST.md), [../40-release/RELEASE_NOTES_v0.1.0.md](../40-release/RELEASE_NOTES_v0.1.0.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with governance metadata.

## Scope lock

- Phase 1 release target: GitHub seed repository only.
- Phase 2 package-manager distribution is out of scope for this runbook.

## Preflight

1. Confirm `v0.1.0` target version and release owner.
2. Confirm default branch and release PR process.
3. Confirm required docs and scripts are present.

## Quality gates

Run from repository root:

```bash
npm install
npm run lab:init -- ./.tmp/release-smoke-<timestamp>
npm run lab:verify
```

Explicit CLI equivalent:

```bash
npm test
npm run validate -- --target examples/minimal-lab
npm run validate -- --target examples/hybrid-governance-lab
npm run init -- --target ./.tmp/release-smoke-<timestamp>
npm run promote -- --target ./.tmp/release-smoke-<timestamp> --to poc
```

Record command outcomes in the release notes.
If wrapper and explicit CLI outcomes differ, treat as release blocker.

## Security and distribution hygiene

1. Verify no credentials/tokens/private keys are tracked.
2. Verify no unintended generated artifacts are tracked.
3. Confirm `.gitignore` excludes local/editor/temp files.

## Release packaging

1. Build initialized lab artifact:
   - `npm run lab:tar -- v0.1.0`
2. Validate artifact from clean extraction:
   - `tar -xzf .tmp/release-artifacts/lab-starter-v0.1.0.tar.gz -C .tmp/release-artifacts`
   - `cd .tmp/release-artifacts/lab-starter-v0.1.0`
   - `node ../../scripts/validate-lab.mjs --target .`
   - `node ../../scripts/promote-stage.mjs --target . --to poc`
3. Finalize release notes with tarball filename and checksum.
4. Merge release PR.
5. Create tag `v0.1.0`.
6. Publish GitHub release with notes, tarball asset, and checksum asset.

## Change history

| Date | Change summary | Major structural change | Editor |
|---|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | yes | Jason Cheroske |

## Sign-off (required only for major structural changes)

| Date | Change reference | Approver (human) | Role | Decision |
|---|---|---|---|---|
| 2026-03-26 | docs taxonomy migration | Jason Cheroske | senior_engineer | approved |
