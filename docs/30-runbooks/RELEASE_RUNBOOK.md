---
created: 2026-03-31
updated: 2026-04-06
---

# Release runbook (GitHub + npm)

**Intent:** Define the canonical run procedure for shipping Lab OS as a **GitHub release** (source + optional tarball) and as the **`lab-os` npm package**.

**Related paths:** [ADOPTION_GUIDE.md](ADOPTION_GUIDE.md), [../40-release/MIGRATION_CHECKLIST.md](../40-release/MIGRATION_CHECKLIST.md), [../40-release/RELEASE_NOTES_v0.2.0.md](../40-release/RELEASE_NOTES_v0.2.0.md), [../40-release/NPM_REGISTRY_GOVERNANCE.md](../40-release/NPM_REGISTRY_GOVERNANCE.md)

**Last reviewed:** 2026-04-06

## Preflight

1. Confirm target version (e.g. `v0.2.0`) and release owner.
2. Confirm default branch and release PR process.
3. Confirm required docs and scripts are present (`NPM_TOKEN` secret and `npm-publish` Environment on GitHub).

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

## Release packaging (GitHub / tarball)

1. **Sync `.ai/` to template:**
   - Copy live `lab-os-lab/.ai/` → `template/.ai/` when the canonical seed should match the working harness copy.
   - Verify `npm run lab:verify` still passes after the sync.
2. Build initialized lab artifact:
   - `npm run lab:tar -- v0.2.0` (adjust version to match release).
3. Validate artifact from clean extraction:
   - `tar -xzf .tmp/release-artifacts/lab-starter-v0.2.0.tar.gz -C .tmp/release-artifacts`
   - `cd .tmp/release-artifacts/lab-starter-v0.2.0`
   - `node ../../scripts/validate-lab.mjs --target .`
   - `node ../../scripts/promote-stage.mjs --target . --to poc`
4. Verify `.ai/` is present in artifact:
   - Confirm `README.md`, `.cursor/skills/lab-init/SKILL.md`, `.cursor/rules/lab-init-default.mdc` (or equivalent) are present.
5. Finalize release notes with tarball filename and checksum.
6. Merge release PR.

## npm publish

1. Ensure `package.json` / `package-lock.json` version matches the release (e.g. `0.2.0`).
2. Create and push an annotated or lightweight tag matching the version:
   - `git tag v0.2.0`
   - `git push origin v0.2.0`
3. The workflow `.github/workflows/npm-publish.yml` runs on `v*.*.*` tags.
4. In GitHub Actions, **approve** the deployment to the **`npm-publish`** environment (required reviewers).
5. After success, confirm on npm:
   - `npm view lab-os version`
6. Smoke from a clean directory:
   - `npx lab-os@latest init --target ./my-lab`
   - `npx lab-os@latest validate --target ./my-lab`

## GitHub release (optional assets)

1. Create GitHub Release for the tag (e.g. `v0.2.0`).
2. Attach `lab-starter-v0.2.0.tar.gz` and checksum if you ship the tarball via Releases.

## Change history

| Date | Change summary | Major structural change | Editor |
|---|---|---|---|
| 2026-04-06 | npm publish section; removed phase-only scope lock; version examples v0.2.0. | yes | — |
| 2026-04-05 | Added `.ai/` sync step to release packaging. | — | — |
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | yes | Jason Cheroske |

## Sign-off (required only for major structural changes)

| Date | Change reference | Approver (human) | Role | Decision |
|---|---|---|---|---|
| 2026-03-26 | docs taxonomy migration | Jason Cheroske | senior_engineer | approved |
