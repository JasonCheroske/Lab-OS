---
created: 2026-03-31
updated: 2026-04-06
---

# GitHub Launch Checklist (Tar-First)

## Artifact plan

- Primary asset: `lab-starter-v0.1.0.tar.gz`
- Integrity asset: `lab-starter-v0.1.0.tar.gz.sha256`
- Secondary path: source repository for custom seed authoring

## Local release sequence

1. `npm install`
2. `npm run lab:tar -- v0.1.0`
3. `npm run lab:init -- ./.tmp/release-smoke-<timestamp>`
4. `npm run lab:verify`
5. `npm test`

## Tar extraction verification

1. `tar -xzf .tmp/release-artifacts/lab-starter-v0.1.0.tar.gz -C .tmp/release-artifacts`
2. `node scripts/validate-lab.mjs --target ./.tmp/release-artifacts/lab-starter-v0.1.0`
3. `node scripts/promote-stage.mjs --target ./.tmp/release-artifacts/lab-starter-v0.1.0 --to poc`

## Commit and tag

1. `git add .`
2. `git commit -m "release: publish tar-first initialized lab workflow"`
3. `git tag v0.1.0`

## Publish with gh

1. `git push -u origin HEAD`
2. `git push origin v0.1.0`
3. `gh release create v0.1.0 --title "Lab OS v0.1.0" --notes-file docs/40-release/RELEASE_NOTES_v0.1.0.md .tmp/release-artifacts/lab-starter-v0.1.0.tar.gz .tmp/release-artifacts/lab-starter-v0.1.0.tar.gz.sha256`
