---
created: 2026-03-31
updated: 2026-03-31
---

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
as described in [docs/40-release/SEMVER_POLICY.md](docs/40-release/SEMVER_POLICY.md).

## [Unreleased]

### Added

- Template **optional root onboarding**: `README.md` and `AGENTS.md` from `template/root/` merged to target on `init`; meta-lab [Seed startup runbook](docs/30-runbooks/SEED_STARTUP_RUNBOOK.md); LAB_CONTRACT and adoption updates.
- Template **optional root `docs/`**: `docs/README.md` and `docs/project-structure.md` copied on `init` (not validated); LAB_CONTRACT companion section; adoption and backlog docs ([`LAB_REALIGNMENT_BACKLOG.md`](docs/90-backlog/LAB_REALIGNMENT_BACKLOG.md)).
- npm publishing workflow, dry-run CI, and external bootstrap smoke workflow.
- `lab-os` CLI (`bin/lab-os.mjs`) for init, validate, promote, lab-init, lab-verify, and lab-tar.
- Documentation: external bootstrap record, npm registry governance, semver policy, ADR-0001 package boundaries.

## [0.1.0] - 2026-03-26

### Added

- Initial public seed release (`v0.1.0`): scaffold, validation, promotion, tarball artifact, and runbooks.

[Unreleased]: https://github.com/REPLACE_WITH_ORG/lab-os-lab/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/REPLACE_WITH_ORG/lab-os-lab/releases/tag/v0.1.0
