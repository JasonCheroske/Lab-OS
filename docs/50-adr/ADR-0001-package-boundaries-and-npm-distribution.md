---
created: 2026-03-31
updated: 2026-03-27
---

# ADR-0001: Package boundaries and npm distribution

**Status:** Accepted  
**Date:** 2026-03-26  
**Intent:** Record the Phase 2 decision for npm distribution: package shape, artifact boundaries, and ownership expectations.

## Context

Phase 2 introduces registry distribution (see [../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md](../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md)). The seed can ship as one package or as multiple packages (`core`, `cli`, `templates`).

## Decision

1. **Package shape:** Ship a **single npm package** named `lab-os` that contains schema, template, scripts, docs, examples, tests, and the `lab-os` CLI entry point. Split packages are deferred until concrete consumers require independent versioning.
2. **Artifact boundaries:** The published tarball includes only paths listed in `package.json` `files` (and always-included `package.json`, `README.md`, `LICENSE`). Consumers run `lab-os` / `npx lab-os` against the embedded `scripts/` and `template/`.
3. **Registry:** **npm** (`registry.npmjs.org`) is the primary public registry.
4. **Ownership:** The npm package `lab-os` is owned by the same GitHub organization that hosts the canonical repository. Maintainer accounts are limited to release owners; **npm automation tokens** exist only as GitHub Actions secrets (see [../40-release/NPM_REGISTRY_GOVERNANCE.md](../40-release/NPM_REGISTRY_GOVERNANCE.md)).
5. **Token rotation:** At least annual review of publish credentials; rotate immediately on maintainer offboarding or suspected leak.

## Consequences

- Versioning and changelog policy apply to the single package (see [../40-release/SEMVER_POLICY.md](../40-release/SEMVER_POLICY.md)).
- CI publishes from tag-driven workflows with environment protection (see `.github/workflows/npm-publish.yml`).

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-03-26 | Initial decision. | Jason Cheroske |
