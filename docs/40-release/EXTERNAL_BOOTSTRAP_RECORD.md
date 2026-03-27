# External bootstrap record

**Intent:** Satisfy the Phase 2 exit criterion that at least one external party has successfully followed seed documentation to bootstrap a lab, and keep a durable record for audits.

**Related paths:** [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md), [../../README.md](../../README.md), [../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md](../90-backlog/PHASE2_PACKAGE_MANAGER_BACKLOG.md)

**Last reviewed:** 2026-03-26

## Definition

- **External** means a person or automation account that is not relying on unpublished repository-only shortcuts: they use published docs (README, release notes, tarball, or npm package) as the source of truth.
- **Successful bootstrap** means the documented path completes through init/validate/promote (or `lab:init` / `lab:verify` equivalent) without release-blocking errors.

## Automated verification (CI)

The workflow **External bootstrap smoke** runs the same commands as the README quick path on every push and pull request. That job is the canonical **non-maintainer** check that published instructions still work from a clean checkout.

| Date (UTC) | Source | Method | Result | Notes |
|------------|--------|--------|--------|-------|
| 2026-03-26 | GitHub Actions | `external-bootstrap-smoke` workflow: `npm ci`, example validations, `lab:init`, `lab:verify` | PASS | See repository `.github/workflows/external-bootstrap-smoke.yml` |

## Human external participants

When a person outside the core maintainer group completes bootstrap using **only** published artifacts and docs, add a row below.

| Date (UTC) | Participant (role optional) | Artifact path (tarball / npm / source tag) | Result | Notes |
|------------|----------------------------|---------------------------------------------|--------|-------|
| | | | | |

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-03-26 | Initial record; CI row + human table. | Jason Cheroske |
