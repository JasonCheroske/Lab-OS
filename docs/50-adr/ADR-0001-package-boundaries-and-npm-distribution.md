---
created: 2026-04-06
updated: 2026-04-17
---

# ADR-0001: Package boundaries and npm distribution

**Status:** Accepted  
**Date:** 2026-03-26  
**Intent:** Record the Phase 2 decision for npm distribution: package shape, artifact boundaries, and ownership expectations.

## Context

Phase 2 introduces registry distribution (see [../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md](../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md)). The seed can ship as one package or as multiple packages (`core`, `cli`, `templates`).

## Decision

1. **Package shape:** Ship a **single npm package** named `lab-os` that contains schema, template, scripts, docs, examples, tests, and the `lab-os` CLI entry point (including `lab-os create` for archetype selection). There is **no** separate `create-*` package: consumers use **`npx lab-os@latest create`** or **`lab-os create`** after `npm install -g lab-os`. Splitting core vs templates as separate versioned artifacts remains deferred until concrete consumers require it.
2. **Artifact boundaries:** The published tarball includes only paths listed in `package.json` `files` (and always-included `package.json`, `README.md`, `LICENSE`). Consumers run `lab-os` / `npx lab-os` against the embedded `scripts/` and `template/`.
3. **Registry:** **npm** (`registry.npmjs.org`) is the primary public registry.
4. **Ownership:** The npm package `lab-os` is owned by the same GitHub organization that hosts the canonical repository. Maintainer accounts are limited to release owners; **npm automation tokens** exist only as GitHub Actions secrets (see [../40-release/NPM_REGISTRY_GOVERNANCE.md](../40-release/NPM_REGISTRY_GOVERNANCE.md)).
5. **Token rotation:** At least annual review of publish credentials; rotate immediately on maintainer offboarding or suspected leak.

## Consequences

- Versioning and changelog policy apply to the single **`lab-os`** artifact (see [../40-release/SEMVER_POLICY.md](../40-release/SEMVER_POLICY.md)).
- CI publishes one package from tag-driven workflows with environment protection (see `.github/workflows/npm-publish.yml`).

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-07 | Single-package policy: no `create-lab-os`; use `npx lab-os create`. | — |
| 2026-03-26 | Initial decision. | Jason Cheroske |
